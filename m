Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbZE0HgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbZE0HgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762567AbZE0H1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:27:53 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46952 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762628AbZE0H1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:27:51 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com
Subject: Microblaze MMU v2
Date: Wed, 27 May 2009 08:47:25 +0200
Message-Id: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This is bunch of patches for Microblaze MMU kernel support version 2.
There is one problem(not functional) with uaccess.h which I know about and I would like
to fix it till rc2 with Arnd's new generic patches which I hope will be there.

All changes are available at git://git.monstr.eu/linux-2.6-microblaze.git
next branch.

Version 1 is available at mmu_v1 branch.

Changes in version 2.
I added all reported problems - mmu_v1 branch contains separate commits for that
I fixed problems with stat.h and fcntl.h - there are prepared for Arnd generic version.

Thanks for your time and review.

I believe that this is the last version for review in LKML.

Thanks for your ACK,
Michal






