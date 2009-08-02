Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZHBVwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZHBVwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZHBVve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:51:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbZHBVvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:51:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christophe Lermytte" <christophe.lermytte@thomson.net>,
       "Dave Jones" <davej@redhat.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
In-Reply-To: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iZB3Pj-uj3M.A.jCC.ucgdKB@chimera>
Subject: [Bug #13872] cpufreq bug (null pointer dereference)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 20:58:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13872
Subject		: cpufreq bug (null pointer dereference)
Submitter	: Christophe Lermytte <christophe.lermytte@thomson.net>
Date		: 2009-07-21 22:07 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ee88415caf736b89500f16e0a545614541a45005
References	: http://marc.info/?l=linux-kernel&m=124820689011112&w=4
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://patchwork.kernel.org/patch/38229/


