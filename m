Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0BAA6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:58:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50596 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab0BAA5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:57:55 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Federico Chiacchiaretta" <federico.chia@gmail.com>,
       "Len Brown" <len.brown@intel.com>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
In-Reply-To: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <de962C6zBxL.A.fRG.SHiZLB@chimera>
Subject: [Bug #14667] bisected 2.6.32 EC regression - Temperatures not correctly detected after suspend - Dell Studio XPS 16 laptop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:43:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14667
Subject		: bisected 2.6.32 EC regression - Temperatures not correctly detected after suspend - Dell Studio XPS 16 laptop
Submitter	: Federico Chiacchiaretta <federico.chia@gmail.com>
Date		: 2009-11-22 20:42 (71 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6a63b06f3c494cc87eade97f081300bda60acec7


