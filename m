Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410Ab0AXWR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0AXWR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388Ab0AXWRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:17:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45559 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab0AXWRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:17:48 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jerome Glisse" <glisse@freedesktop.org>,
       "John Kacur" <jkacur@redhat.com>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
In-Reply-To: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hE3x9c-4KZM.A.jKF.9JMXLB@chimera>
Subject: [Bug #15131] [OOPS] radeon kms
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:04:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15131
Subject		: [OOPS] radeon kms
Submitter	: John Kacur <jkacur@redhat.com>
Date		: 2010-01-15 15:45 (10 days old)
References	: http://lkml.org/lkml/2010/1/15/129
Handled-By	: Jerome Glisse <glisse@freedesktop.org>
Patch		: http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=patch;h=30d2d9a54d48e4fefede0389ded1b6fc2d44a522


