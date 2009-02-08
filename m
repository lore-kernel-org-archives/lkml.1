Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZBHV4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZBHV4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZBHVtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:49:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbZBHVtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:49:16 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@linux.ie>, "Dave Airlie" <airlied@redhat.com>,
       "etienne" <etienne.basset@numericable.fr>,
       "Soeren Sonnenburg" <kernel@nn7.de>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.HiF.r20jJB@chimera>
Subject: [Bug #12613] [Suspend regression][DRM, RADEON]
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:44 +0100 (CET)
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
Date		: 2009-01-28 22:00 (12 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4


