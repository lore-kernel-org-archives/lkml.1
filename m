Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbXLWOvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbXLWOvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXLWOvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:35864 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbXLWOvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:37 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 00/50] KVM patch queue review for 2.6.25 merge window (part I)
Date: Sun, 23 Dec 2007 16:50:45 +0200
Message-Id: <1198421495-31481-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the first part of the 2.6.25 merge window submission.  Since
there are 238 patches in the queue (and a few more expected), they'll be
sent in five batches of around 50 each.
