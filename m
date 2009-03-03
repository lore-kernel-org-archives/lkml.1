Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbZCCWHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbZCCWHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZCCWAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39376 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237AbZCCWAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:00:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>, "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.9EC.AVarJB@chimera>
Subject: [Bug #12764] Can not ioremap virtual address for G33 hw status page
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12764
Subject		: Can not ioremap virtual address for G33 hw status page
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-02-23 14:46 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6fb88588555a18792a27f483887fe1f2af5f9c9b
References	: http://marc.info/?l=linux-kernel&m=123540053219505&w=4


