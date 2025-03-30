using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Mommosoft.ExpertSystem;
using System.Diagnostics;

namespace CP463_ExpertSysProj
{
    public partial class Form1 : Form
    {
        private Mommosoft.ExpertSystem.Environment _theEnv = new Mommosoft.ExpertSystem.Environment();
        public Form1() {
            ConsoleTraceListener tl = new ConsoleTraceListener();
            InitializeComponent();
            _theEnv.AddRouter(new DebugRouter());
            _theEnv.Load("HostPackage.clp");
            _theEnv.Reset();
            
        }

        protected override void OnLoad(EventArgs e) {
            base.OnLoad(e);
            NextUIState();
        }

        private void OnClickButton(object sender, EventArgs e) {
            Button button = sender as Button;
            // Get the state-list.
            String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
            using (FactAddressValue f = (FactAddressValue)((MultifieldValue)_theEnv.Eval(evalStr))[0]) {
                string currentID = f.GetFactSlot("current").ToString();

                if (button.Tag.Equals("Next")) {
                    if (GetCheckedChoiceButton() == null) { _theEnv.AssertString("(next " + currentID + ")"); } else {
                        _theEnv.AssertString("(next " + currentID + " " +
                                           (string)GetCheckedChoiceButton().Tag + ")");
                    }
                    NextUIState();
                } else if (button.Tag.Equals("Restart")) {
                    _theEnv.Reset();
                    NextUIState();
                } else if (button.Tag.Equals("Prev")) {
                    _theEnv.AssertString("(prev " + currentID + ")");
                    NextUIState();
                }
            }
        }

        private void NextUIState() {
            nextButton.Visible = false;
            prevButton.Visible = false;
            choicesPanel.Controls.Clear();
            _theEnv.Run();
           
            // Get the state-list.
            String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
            using (FactAddressValue allFacts = (FactAddressValue)((MultifieldValue)_theEnv.Eval(evalStr))[0]) {
                string currentID = allFacts.GetFactSlot("current").ToString();
                evalStr = "(find-all-facts ((?f UI-state)) " +
                               "(eq ?f:id " + currentID + "))";
            }

            using (FactAddressValue evalFact = (FactAddressValue)((MultifieldValue)_theEnv.Eval(evalStr))[0]) {
                string state = evalFact.GetFactSlot("state").ToString();
                if (state.Equals("initial")) {
                    nextButton.Visible = true;
                    nextButton.Tag = "Next";
                    nextButton.Text = "Next";
                    prevButton.Visible = false;
                    pictureBox1.Visible = false;
                } else if (state.Equals("final")) {
                    nextButton.Visible = true;
                    nextButton.Tag = "Restart";
                    nextButton.Text = "Restart";
                    prevButton.Visible = false;
                } else {
                    nextButton.Visible = true;
                    nextButton.Tag = "Next";
                    prevButton.Tag = "Prev";
                    prevButton.Visible = true;
                }

                using (MultifieldValue validAnswers = (MultifieldValue)evalFact.GetFactSlot("valid-answers")) {
                    String selected = evalFact.GetFactSlot("response").ToString();
                    for (int i = 0; i < validAnswers.Count; i++) {
                        RadioButton rb = new RadioButton();
                        rb.Text = (SymbolValue)validAnswers[i];
                        rb.Tag = rb.Text;
                        rb.Visible = true;
                        rb.Location = new Point(10, 20 * (i + 1));
                        choicesPanel.Controls.Add(rb);
                    }
                }
                messageLabel.Text = GetString((SymbolValue)evalFact.GetFactSlot("display"));

                String states = evalFact.GetFactSlot("state").ToString();
                if (states.Equals("final")){
                    String result = GetString((SymbolValue)evalFact.GetFactSlot("display"));
                   // MessageBox.Show
                    if (result.Equals("My suggestion is no suitible package"))
                    {
                        MessageBox.Show(result, "Package Suggestion",
                        MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    }
                    else
                    {
                        //Form2 form2 = new Form2();
                        //form2.Show();
                        //MessageBox.Show("555", "Package Suggestion",
                        //MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation);
                        //pictureBox1.Image()
                        GetImage((SymbolValue)evalFact.GetFactSlot("display"));
                    }
                }

            }
        }

        private void ShowChoices(bool visible) {
            foreach (Control control in choicesPanel.Controls) {
                control.Visible = visible;
            }
        }

        private RadioButton GetCheckedChoiceButton() {
            foreach (RadioButton control in choicesPanel.Controls) {
                if (control.Checked) {
                    return control;
                }
            }
            return null;
        }
        
        private string GetString(string name) {
            return FACT.ResourceManager.GetString(name);
        }

        private void GetImage(string name)
        {
            System.Drawing.Image packageImg;
            object obj = PICTURE.ResourceManager.GetObject(name);
            //return ((System.Drawing.Icon)(obj));
            //pictureBox1.Image = PICTURE.dedicateServerCon;
            //pictureBox1.Image = System.Drawing.Image.FromFile(obj);
            packageImg = (System.Drawing.Image)obj;
            pictureBox1.Image = packageImg;
            pictureBox1.Visible = true;
        }

    }
}
