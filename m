Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbZBXAYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbZBXAYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZBXATy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:19:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42505 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560AbZBXATt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:19:49 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@linux.ie>, "Dave Airlie" <airlied@redhat.com>,
       "etienne" <etienne.basset@numericable.fr>,
       "Soeren Sonnenburg" <kernel@nn7.de>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vP9hdyF4fL.A.WIF.xpzoJB@chimera>
Subject: [Bug #12613] [Suspend regression][DRM, RADEON]
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 22:48:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12613
Subject		: [Suspend regression][DRM, RADEON]
Submitter	: etienne <etienne.basset@numericable.fr>
Date		: 2009-01-28 22:00 (27 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
		  http://lkml.org/lkml/2009/2/8/203
Patch		: http://lkml.org/lkml/2009/2/15/28


