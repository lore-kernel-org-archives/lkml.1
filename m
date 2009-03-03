Return-Path: <linux-kernel-owner+w=401wt.eu-S1760961AbZCCWKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961AbZCCWKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbZCCWBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:01:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39410 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006AbZCCWBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:01:08 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>, "Eric Anholt" <eric@anholt.net>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.QeB.sUarJB@chimera>
Subject: [Bug #12806] i915 broken STR
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12806
Subject		: i915 broken STR
Submitter	: Harvey Harrison <harvey.harrison@gmail.com>
Date		: 2009-02-28 4:20 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5669fcacc58bf3a7386057addffd280d75380858
References	: http://marc.info/?l=linux-kernel&m=123579487801064&w=4


