Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbXJVSMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbXJVSMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXJVSMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22167 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXJVSMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:24 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH 00/10] SG updates
Date: Mon, 22 Oct 2007 20:10:54 +0200
Message-Id: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I split the patch up into a few pieces, so it can be applied safely.
It builds with allyesconfig on i386 and x86-64, and it's been booted
and tested on both those archs and ppc64 as well.

The same patch series can also be applied by pulling

  git://git.kernel.dk/linux-2.6-block.git sg



