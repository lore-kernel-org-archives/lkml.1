Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbZBXA3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbZBXA3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbZBXAUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:20:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42588 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757975AbZBXAUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:20:53 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>, "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vP9hdyF4fL.A.L6C.zozoJB@chimera>
Subject: [Bug #12764] Can not ioremap virtual address for G33 hw status page
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 22:48:17 +0100 (CET)
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
Date		: 2009-02-23 14:46 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6fb88588555a18792a27f483887fe1f2af5f9c9b
References	: http://marc.info/?l=linux-kernel&m=123540053219505&w=4


