Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbXCHQg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbXCHQg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXCHQg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:36:29 -0500
Received: from web52506.mail.yahoo.com ([206.190.48.189]:20230 "HELO
	web52506.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752424AbXCHQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:36:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=HcpP12YBub5/ls63ZWmob6kHPQ42+TrqI3G1zm2F0Xqgoc6RHLY3qoHVnbJNMSnhICD2VWGFbG0bGUe91myQNrKiBgHqXsMNbt/njKo4eSVEL9GhXXWIl5APpWo1S8XiQ0sLsT9tpauN3KYVzLIYThuMVCO6kMH9bzNCQ/wQOkI=;
X-YMail-OSG: 5a8oYbEVM1mmc2Ql7p_apbKNhvCKUNSLTW6gM916CQabYNjIC_8PU2nphObEGm44AwPE4GEp_PVijJ0WrwMZc42fjsxksLMv35beZyaQBXU_OIx6rux_f8k5SPggkGFDKip4nCeyJwhOkVJbbLtv7O23W2LTyr0lqK.uN5fG.QRZ.n55x7uFPGUba_pS
Date: Thu, 8 Mar 2007 08:36:23 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Networking Question [ot]
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <502137.93252.qm@web52506.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This may be a little off topic but I know there's
people here that can give me a quick answer.

I'm running Fedora Core 6 and I have two blocks of IP
addresses on eth0.

69.50.231.0/28
69.50.231.128/26

Do I need to set some kind of static route so that IPs
in one set can talk to the other? If so - how do I do
that?

Thanks in advance.



 
____________________________________________________________________________________
Food fight? Enjoy some healthy debate 
in the Yahoo! Answers Food & Drink Q&A.
http://answers.yahoo.com/dir/?link=list&sid=396545367
