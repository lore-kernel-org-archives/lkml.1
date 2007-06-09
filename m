Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbXFIRky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbXFIRky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbXFIRkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:40:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:5598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbXFIRkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=GqaLbmw1L8x+wNgqf+O25FjDlKhbatYJbed6lCnDAXTL0D4f6XVA5ZnsxNIpDqXWbiU3Q1dFowyVOEOAELknCWEtuH6er9Jc0vFzWGfYpRKtKJO53uOKV+qRQF2BE1uj5Zr3ZOwz7m2Ompdqenf6WgG0o2k9hig9YlxQLJRZJxU=
Message-ID: <466AE606.7020704@googlemail.com>
Date: Sat, 09 Jun 2007 19:40:22 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Rodrigo Luiz <troops.of.doom@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Suresh B <suresh.b.siddha@intel.com>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Gary Zambrano <zambrano@broadcom.com>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [1/3] 2.6.22-rc4: known regressions v2
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : nanosleep(0) behaviour
References : http://lkml.org/lkml/2007/5/27/108
             http://lkml.org/lkml/2007/6/4/239
Submitter  : Maximilian Engelhardt <maxi@daemonizer.de>
Handled-By : Gary Zambrano <zambrano@broadcom.com>
             Michael Buesch <mb@bu3sch.de>
             Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged

Subject    : Kernel hang on CMOS_READ
References : http://lkml.org/lkml/2007/6/3/138
Submitter  : Rodrigo Luiz <troops.of.doom@gmail.com>
Status     : Unknown


Subject    : Device hang when offlining a CPU due to IRQ misrouting
References : http://lkml.org/lkml/2007/5/31/419
Submitter  : Darrick J. Wong <djwong@us.ibm.com>
Handled-By : Siddha, Suresh B <suresh.b.siddha@intel.com>
Status     : problem is being debugged

Subject    : long freezes on thinkpad t60
References : http://lkml.org/lkml/2007/5/24/100
Submitter  : Miklos Szeredi <miklos@szeredi.hu>
Handled-By : Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
