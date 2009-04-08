Return-Path: <linux-kernel-owner+w=401wt.eu-S933691AbZDHOPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbZDHOPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933203AbZDHOKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:10:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:35397 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765252AbZDHOKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:10:49 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: beckyb@kernel.crashing.org
Subject: [PATCH V3 0/7] swiotlb: changes for powerpc/highmem
Date: Wed,  8 Apr 2009 09:09:14 -0500
Message-Id: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a repost of Becky's patches from the v2 version.  The only change
is to incorporate feedback on "Create swiotlb_unmap_single" an to add
Ack by FUJITA Tomonori for patches that have been reviewed.

- k
