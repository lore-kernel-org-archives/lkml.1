Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbZHZKc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbZHZKc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbZHZKbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:31:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138AbZHZKaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 39/47] Documentation: Update KVM list email address
Date: Wed, 26 Aug 2009 13:30:01 +0300
Message-Id: <1251282609-12835-40-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

The KVM list moved to vger.kernel.org last year

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 Documentation/ioctl/ioctl-number.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 7bb0d93..3223e12 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -191,7 +191,7 @@ Code	Seq#	Include File		Comments
 0xAD	00	Netfilter device	in development:
 					<mailto:rusty@rustcorp.com.au>	
 0xAE	all	linux/kvm.h		Kernel-based Virtual Machine
-					<mailto:kvm-devel@lists.sourceforge.net>
+					<mailto:kvm@vger.kernel.org>
 0xB0	all	RATIO devices		in development:
 					<mailto:vgo@ratio.de>
 0xB1	00-1F	PPPoX			<mailto:mostrows@styx.uwaterloo.ca>
-- 
1.6.4.1

