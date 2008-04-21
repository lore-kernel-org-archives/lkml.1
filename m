Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYDUKaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYDUKaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYDUKaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:01 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37843
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYDUK37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:29:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/31] KVM: Register ioctl range
Date: Mon, 21 Apr 2008 13:29:28 +0300
Message-Id: <1208773797-7829-3-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 Documentation/ioctl-number.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
index c18363b..240ce7a 100644
--- a/Documentation/ioctl-number.txt
+++ b/Documentation/ioctl-number.txt
@@ -183,6 +183,8 @@ Code	Seq#	Include File		Comments
 0xAC	00-1F	linux/raw.h
 0xAD	00	Netfilter device	in development:
 					<mailto:rusty@rustcorp.com.au>	
+0xAE	all	linux/kvm.h		Kernel-based Virtual Machine
+					<mailto:kvm-devel@lists.sourceforge.net>
 0xB0	all	RATIO devices		in development:
 					<mailto:vgo@ratio.de>
 0xB1	00-1F	PPPoX			<mailto:mostrows@styx.uwaterloo.ca>
-- 
1.5.5

