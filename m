Return-Path: <linux-kernel-owner+w=401wt.eu-S1764808AbXESWHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764808AbXESWHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759446AbXESWGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:06:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:9019 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764709AbXESWGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=o1Oj5v7mLzDawf/tIj8/nIA6ttwp8Iepi92KwiwQjx4N66l4qPkwnDcle9po3z4rQ3WWt45BwMJC7nTUHOsvH9/u+efr9L4bpr2hzbV7EgYgOfPMVHMmSrCIaqsw4la+bk8Vo/3aMnqB1zqp805ZsM5vaMMB04d5qcuHyWO8oKE=
Message-ID: <464F74BB.9070402@googlemail.com>
Date: Sun, 20 May 2007 00:05:47 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Ray Lee <ray-lk@madrabbit.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Ben Collins <bcollins@ubuntu.com>,
       =?ISO-8859-2?Q?Matthias_Bl=E4sing?= 
	<matthias.blaesing@rwth-aachen.de>
Subject: [1/5] 2.6.22-rc2: known regressions
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : 2.6.22-rc2 prepatch breaks compile on Dreamcast
References : http://lkml.org/lkml/2007/5/19/75
Submitter  : Adrian McMenamin <adrian@newgolddream.dyndns.info>
Status     : Unknown



ACPI

Subject    : acpi hangs on boot
References : http://bugzilla.kernel.org/show_bug.cgi?id=8504
Submitter  : Matthias Bläsing <matthias.blaesing@rwth-aachen.de>
Status     : Unknown

Subject    : BAT0 no longer seen, ACPI errors
References : http://bugzilla.kernel.org/show_bug.cgi?id=8493
Submitter  : Ben Collins <bcollins@ubuntu.com>
Status     : Unknown

Subject    : cannot change thermal trip points
References : http://lkml.org/lkml/2007/5/17/139
Submitter  : Maciej Rutecki <maciej.rutecki@gmail.com>
Status     : Unknown

Subject    : nx6125 has lost fan control
References : http://lkml.org/lkml/2007/5/16/249
Submitter  : Ray Lee <ray-lk@madrabbit.org>
Status     : Unknown



Regards,
Michal

--
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
