Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYIHJz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYIHJz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYIHJzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:55:16 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:48716 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYIHJzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:55:16 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tony.luck@intel.com
Subject: [PATCH 0/3] minor cleanups for swiotlb
Date: Mon,  8 Sep 2008 18:53:47 +0900
Message-Id: <1220867630-1995-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is minor cleanups for swiotlb. It doesn't confilict with
the swiotlb fixes for the x86 tree (that I've just sent):

http://lkml.org/lkml/2008/9/8/30

This can be cleanly applied to tip/master and tip/x86/iommu.

Ingo, can you apply this to your tree?



