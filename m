Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbXKBFEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbXKBFEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 01:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbXKBFDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 01:03:53 -0400
Received: from n6.bullet.mud.yahoo.com ([216.252.100.57]:32568 "HELO
	n6.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751027AbXKBFDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 01:03:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 660409.94788.bm@omp109.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=HYIk+tGdJDYOhaamjMBrgvatfLo9/N2VcppwpN6wyMBe6xI98kJuhtOzMrpaEVxE037ykOc8zScVXVf1Xwghq1etCxlfKHrZ/0yoiBaGmtXEoy5xbvvyXqkrHxC7x/4IqyOOWpEmtzpvx5JM5SpeS8h8rIA1tci67XEuZimnu6o=;
X-YMail-OSG: zcBAlgsVM1npj70zcSTiGKcAZF7C7USAUiLvHnXTJXeIPTTwW_JswRhF_ZtVklRV94A5UehWBfeosFm8jwJCRpHyURwMNskOtDPXOpnme28Rl3Z2HZ8oMzJwk02xHg--
X-Mailer: YahooMailRC/814.06 YahooMailWebService/0.7.134.12
Date: Fri, 2 Nov 2007 10:33:49 +0530 (IST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: NPTL support
To: uclibc@uclibc.org, linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>, buildroot@uclibc.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <335463.37228.qm@web8414.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to build the toolchain for MIPS processor using buildroot.
I am using gcc version of 3.4.3, binutils-2.15, uclibc-0.9.28 and linux-2.6.18.8 kernel.

Basically i need to enable NPTL feature support in my toolchain.
does uclibc-0.9.28 has the support for NPTL?
If not, how can i get it enabled for my above build configuration?

I see there is separate branch "uclibc-nptl" in uclibc. 
Do i need to use this (uclibc-nptl) to meet my requirement?

Could you please suggest me right approach to succssfully enable NPTL?

Thanks in advance.

Regards,
Veerasena.


      Why delete messages? Unlimited storage is just a click away. Go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html

