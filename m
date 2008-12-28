Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbYL1GFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbYL1GFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 01:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYL1GFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 01:05:32 -0500
Received: from sh.osrg.net ([192.16.179.4]:53864 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbYL1GFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 01:05:31 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tony.luck@intel.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/3] swiotlb cleanups
Date: Sun, 28 Dec 2008 15:02:04 +0900
Message-Id: <1230444127-587-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is minor swiotlb cleanups. It depends on the swiotlb highmem
patchset:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git swiotlb


