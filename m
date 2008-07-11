Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbYGKBYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbYGKBYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYGKBYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:24:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:48431 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbYGKBYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:24:41 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/4] x86: IOMMU cleanups
Date: Fri, 11 Jul 2008 10:23:41 +0900
Message-Id: <1215739425-28399-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up IOMMU stuff, including a sequel to the GART
cleanups:

http://lkml.org/lkml/2008/7/9/488

This is against tip/master.


