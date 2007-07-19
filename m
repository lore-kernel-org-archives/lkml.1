Return-Path: <linux-kernel-owner+w=401wt.eu-S938760AbXGSQC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938760AbXGSQC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762129AbXGSQCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:02:43 -0400
Received: from web56615.mail.re3.yahoo.com ([66.196.97.59]:38606 "HELO
	web56615.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760420AbXGSQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:02:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=vWn+YF/tiehnx9KT0c/27ZtNxtPHMTA+1qiJKtOgZVQ4rKsMfgHLV0spYkSVWJRJovEkJ3umgWLcf6vNJcqPSqYgVDIDLvk0HYSSRfBMk3hqUkSBtXya5s/kZfnzbmAE8bPI23t76/XS1yh1sIAelh/oEg7ayv6+0OCA0kpRAQ8=;
X-YMail-OSG: LWMSmJwVM1nQJnqmUYcyqe5mTL2xAv3AdMOMhapXkurSeOppXs0msmTfItel8bJ8M2btlK6TEUePlO.CKAyFp1yoxARUHDAocJZBahJtbNgAKhEZekN_TOIcHsKbQQ--
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.41.16
Date: Thu, 19 Jul 2007 09:02:38 -0700 (PDT)
From: andrei radulescu-banu <iubica2@yahoo.com>
Subject: Re: Linux, tcpdump and vlan
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>
Cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <997818.30021.qm@web56615.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One additional thought: with the proposed changes in my prev message, the driver can be set to hw vlan accelerated mode, even if no vlan interfaces are configured. We would not have to switch hw vlan accelerated mode anymore, when vlan interfaces are created or destroyed.






       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433
