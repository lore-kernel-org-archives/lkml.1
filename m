Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZE0BY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZE0BY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZE0BYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:24:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:52962 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbZE0BYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:24:36 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip 0/3] dma-debug fixes
Date: Wed, 27 May 2009 09:43:00 +0900
Message-Id: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 27 May 2009 10:24:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of them is critical (we get bogus warnings due to the bugs but
the bugs are in unpopular DMA mapping functions).

This patchset is against to tip/master.


