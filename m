Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZBXAT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZBXAT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZBXATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:19:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42475 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbZBXATH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:19:07 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vP9hdyF4fL.A.5KG.KrzoJB@chimera>
Subject: [Bug #12418] Repeated ioctl(4, 0x40046445, ..) loop in glxgears
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 22:48:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12418
Subject		: Repeated ioctl(4, 0x40046445, ..) loop in glxgears
Submitter	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date		: 2009-01-07 22:43 (48 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
References	: http://marc.info/?l=linux-kernel&m=123136836213319&w=4


