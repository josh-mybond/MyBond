class AdjustPrivacyPolicy < ActiveRecord::Migration[6.0]
  def change
    p = PrivacyPolicy.new
    p.status = 1 # published
    p.summary = ""
    p.full    = %(
    <h2 class="text-center">PRIVACY STATEMENT</h2>
    <h3 class="text-center">MyBond</h3>
    <p>
      <strong>
        Collection of personal information
      </strong>
    </p>
    <p>
      MyBond Group Pty Ltd ACN 27 644 744 972 (<strong>MyBond</strong> or <strong>we/us</strong>) collects personal information about the individuals it deals with. Wherever it is reasonably practicable for us to do so, we will collect a person's personal information directly from the individual concerned. This Privacy Statement provides some relevant details about how we collect, handle and use the personal information we collect. You can obtain further information by viewing the applicable MyBond Privacy Policy at www.mybond.com.au.
    </p>
    <p>
      We will usually collect personal information in order to better allow us to provide our products and services. If you do not provide us with personal information that we request in relation to the provision (or proposed provision) of our products or services, it may affect or limit our ability to provide such products or services.
    </p>
    <p>
      Before MyBond provides a financial product or service to you, or to a person connected with you, we may (where you are an individual) be required to collect your full name, residential address and date of birth. We may be required to do this in order for MyBond to comply with its customer identification obligations under the Anti-Money Laundering and Counter-Terrorism Financing Act 2006. As a part of such process we may need to take copies of your personal identification documents in order to verify your identity in accordance with the requirements of that Act.
    </p>
    <h4>How we collect personal information</h4>
    <p>
      In most instances, we will collect information about you:
    </p>
    <ul class="text-muted">
      <li>from an application form completed by you or by a person connected to you;</li>
      <li>from information provide to us by you or by a person seeking finance from MyBond (including through</li>
    the Website or our mobile application);</li>
      <li>from information you otherwise provide to us, or our agents;</li>
      <li>from conducting site visits to obtain information;</li>
      <li>from external data providers we use, as well as other vendors and social media;</li>
      <li>from other credit providers;</li>
      <li>by accessing public databases, such as those maintained by the Australian Securities and Investments
    Commission;</li>
      <li>by seeking verification information in relation to your identity from a third party, such as a credit reporting
    body;</li>
      <li>by obtaining other information from third party commercial and business information providers; and/or
      <li>by email request to you or by telephone contact with you.</li>
    </ul>
    <p>
      We will not collect sensitive information about you without your consent.
    </p>
    <h4>
      Uses and disclosure of personal information
    </h4>
    <p>
      Where we collect your personal information, it will be to allow us to:
    </p>
    <ul class="text-muted">
      <li>identify you, or conduct appropriate due diligence;</li>
      <li>assess and process your request and application for a financial product or service;</li>
      <li>assess and process a request for the provision of a financial product or service to a person or entity
    connected with you;</li>
      <li>operate, maintain, improve and provide a financial product or service to you, or a person or entity
    connected with you;</li>
      <li>open and maintain a loan account for you, or the account of a person or entity connected with you;</li>
      <li>complete and manage our transactions with you, including by deducting periodic payments due;</li>
      <li>communicate with you to send confirmations and to send account update notifications;</li>
      <li>manage our relationship with you, or a person or entity connected with you, and respond to customer
    requests;</li>
      <li>help us to assess products that may suit your financial needs or the needs of a person or entity
    connected with you;</li>
      <li>send marketing communications and notify you of any products that may be of interest to you or a
    person or entity connected with you;</li>
      <li>audit and monitor the services we provide to you or a person or entity connected with you;</li>
      <li>assist us to perform administrative or operational task (including risk management, systems development and testing, credit scoring, staff training and customer research);</li>
      <li>investigate, identify or prevent any actual or suspected fraud or unlawful activity;</li>
      <li>update the personal information we hold about you or the files of a person or entity connected with you; enable us to meet our obligations under law, including under the Anti-Money Laundering and Counter-Terrorism Financing Act 2006 (Cth); and/or</li>
      <li>produce data analytics and reports containing anonymised summaries derived from personal information and other information that is not personal information that we may then share with business partners.</li>
    </ul>
    <p>
      We may disclose your personal information to:
    </p>
    <ul class="text-muted">
      <li>your insurer;</li>
      <li>our related companies;</li>
      <li>our business partners, service providers, subsidiaries and affiliates that are assisting in the review or processing of a credit application with which you are connected, or with the provision of our services, such as by providing data storage and other similar services;</li>
      <li>our agents, the person who introduced you to us, contractors or other third party service providers, to enable them to provide administrative and other support services to us;</li>
      <li>credit reporting bodies, such as Veda Advantage Information Services and Solutions Limited;</li>
      <li>other credit providers;</li>
      <li>other financial institutions in connection with a credit application with which you are connected or in connection with your dealings with us;</li>
      <li>your authorised agents or your executor, administrator or legal representative; and/or</li>
      <li>government agencies and regulatory bodies as part of our statutory obligations, or for law enforcement purposes.</li>
    </ul>
    <h4>
      Credit Reporting
    </h4>
    <p>
      MyBond may also disclose personal information, including information about your other credit liabilities, repayments and defaults, to credit reporting bodies. We also collect this information from credit reporting bodies. Information is available on our website about credit reporting (including the name and contact details of these credit reporting bodies) and about when MyBond may disclose your personal information to them (to include in a report about your credit worthiness), as well as information about how you can request credit reporting bodies not to use your information in certain circumstances.
    </p>
    <h4>
      Overseas disclosures
    </h4>
    <p>
      As is the case with many industries, technology allows for services to be provided by different service providers including some that are located overseas. We rely on overseas service providers for some of our activities and to do so may need to disclose personal information to those service providers. We may also disclose your personal information to our related companies, business partners, and affiliates who are located overseas. This may include a disclosure to entities not established in Australia or that do not carry on business in Australia. It is likely that such disclosures will be made to persons in countries including New Zealand.
    </p>
    <h4>
      MyBond Privacy Policy
    </h4>
    <p>
      The applicable MyBond Privacy Policy contains information about how you may request access to personal information that we hold about you and seek correction of that information. It also contains information about how you may complain about a breach of the Privacy Act, the Australian Privacy Principles or an applicable code and about how we will deal with such a complaint.
    </p>
    <h4>
      Marketing and option to opt out
    </h4>
    <p>
      MyBond may contact you to offer you products and services that may be of interest to you. You may choose to stop receiving our marketing material and telephone solicitations or other forms of contact from MyBond by following the unsubscribe instructions included in our emails or by contacting us by email at contact@mybond.com.au (and including your full name and business mailing email addresses and account number) or by post to our contact address below.
    </p>
    <address class="text-muted">
      MyBond Group<br />
      Level 4/ 11 York Street, <br />
      Sydney, NSW, 2000
    </address>
    <h4>
      Personal information you provide about someone else
    </h4>
    <p>
      If you give MyBond personal information about someone else, please show them a copy of this Privacy Statement so that they may understand the manner in which their personal information may be used or disclosed by MyBond in connection with your dealings with MyBond.
    </p>
    )
    p.save
  end
end
