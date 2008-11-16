Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYKPSfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYKPSfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYKPSeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:34:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbYKPSeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:34:19 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andreas Mohr" <andi@lisas.de>, "Lukas Hejtmanek" <xhejtman@fi.muni.cz>,
       =?utf-8?q?=C5=81ukasz=20Siudut?= <lsiudut@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.VRG.eBGIJB@chimera>
Subject: [Bug #11905] lots of extra timer interrupts costing 2W
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11905
Subject		: lots of extra timer interrupts costing 2W
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2008-10-30 2:18 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fb02fbc14d17837b4b7b02dbb36142c16a7bf208
References	: http://marc.info/?l=linux-kernel&m=122533314305315&w=4
		  http://marc.info/?l=linux-kernel&m=122541849114444&w=4


