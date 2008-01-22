Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbYAVNJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbYAVNJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYAVNJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:09:41 -0500
Received: from bde.crans.org ([138.231.137.76]:47787 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYAVNJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:09:40 -0500
From: Mathieu Segaud <mathieu.segaud@regala.cx>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sct@redhat.com
Subject: [RESENT] Fix previously extX_ioctl() patches
Date: Tue, 22 Jan 2008 14:09:33 +0100
Message-Id: <1201007375-27914-1-git-send-email-mathieu.segaud@regala.cx>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This two patches discards and replaces 2 previously sent patches
they convert ext3/4_ioctl()s to unlocked_ioctl's


