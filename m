Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZIFU3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZIFU3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758606AbZIFU3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:29:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48830 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567AbZIFU3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:29:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Carlos R. Mafra" <crmafra2@gmail.com>, "Eric Anholt" <eric@anholt.net>,
       "Ma Ling" <ling.ma@intel.com>, "Zhao Yakui" <yakui.zhao@intel.com>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
In-Reply-To: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vm51Upp4EV.A.cnB._eBpKB@chimera>
Subject: [Bug #14139] Output to external monitor is broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 19:24:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14139
Subject		: Output to external monitor is broken
Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
Date		: 2009-09-06 14:22 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f8aed700c6ec46ddade6570004ce25332283b306
References	: http://marc.info/?l=linux-kernel&m=125224701520738&w=4


