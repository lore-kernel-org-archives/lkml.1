Return-Path: <linux-kernel-owner+w=401wt.eu-S1161356AbXCGJB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161356AbXCGJB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXCGJBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:01:34 -0500
Received: from il.qumranet.com ([82.166.9.18]:38182 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030502AbXCGJBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:01:32 -0500
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: Fixes for 2.6.21-rc3
Date: Wed,  7 Mar 2007 11:01:27 +0200
Message-Id: <1173258089147-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains fixes I plan to submit pre 2.6.21.  One
improves cleanup on module load failures, while the other fixes guest
failures in compat mode (32-bit guest process on a 64-bit guest kernel).

