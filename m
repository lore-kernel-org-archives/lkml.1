Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZE3Wfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZE3Wfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZE3WfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:35:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46451 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZE3WfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:35:09 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>, "Len Brown" <len.brown@intel.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Thomas Renninger" <trenn@suse.de>, "Zhang Rui" <rui.zhang@intel.com>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
In-Reply-To: <4to6E2myxvG.A.muC.aIbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LEcEO2518_I.A.fJF.hKbIKB@chimera>
Subject: [Bug #13121] Buggy _BCM - acer aspire 5720G, 5710Z, 5315
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:37:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13121
Subject		: Buggy _BCM - acer aspire 5720G, 5710Z, 5315
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2009-04-16 11:37 (45 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1a7c618a3f7bef1a20ae740df512eeba21397fa5
References	: http://marc.info/?l=linux-kernel&m=123988189401913&w=4
Handled-By	: Zhang Rui <rui.zhang@intel.com>
Patch		: http://patchwork.kernel.org/patch/19755/
		  http://bugzilla.kernel.org/attachment.cgi?id=21268


