Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbXCKKHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbXCKKHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 06:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXCKKHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 06:07:13 -0400
Received: from il.qumranet.com ([82.166.9.18]:51135 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXCKKHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 06:07:10 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: More fixes for 2.6.21-rc3
Date: Sun, 11 Mar 2007 12:07:06 +0200
Message-Id: <11736076283998-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains fixes I plan to submit pre 2.6.21: a fix for
large memory 32-bit hosts, and a fix for non-pae 32-bit guests.


