Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516AbYLMSmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbYLMSmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 13:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYLMSlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 13:41:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYLMSlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 13:41:21 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?C=C3=A9dric=20Godin?=" <cedric@belbone.be>,
       "Dave Airlie" <airlied@gmail.com>, "Dave Airlie" <airlied@redhat.com>,
       "Keith Packard" <keithp@keithp.com>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
In-Reply-To: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <T1gm2CtAHBF.A.8MH.m4_QJB@chimera>
Subject: [Bug #12178] Xorg crash at first start
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 13 Dec 2008 17:33:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12178
Subject		: Xorg crash at first start
Submitter	: Cédric Godin <cedric@belbone.be>
Date		: 2008-12-04 14:26 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=52440211dcdc52c0b757f8b34d122e11b12cdd50
References	: http://marc.info/?l=linux-kernel&m=122840082828098&w=4


