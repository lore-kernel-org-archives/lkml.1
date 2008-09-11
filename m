Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYIKOLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYIKOLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYIKOLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:11:12 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:49264 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbYIKOLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:11:11 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/2] x86: fixes for the allow_coherent rewrite (tip/x86/iommu)
Date: Thu, 11 Sep 2008 23:08:46 +0900
Message-Id: <1221142128-28350-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the final patchset for the allow_coherent rewrite (hopefully).


