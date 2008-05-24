Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbYEXRWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbYEXRWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbYEXRWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:22:13 -0400
Received: from host135-133-dynamic.55-82-r.retail.telecomitalia.it ([82.55.133.135]:29457
	"EHLO linux.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757347AbYEXRWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:22:12 -0400
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com, menage@google.com
Cc: matt@bluehost.com, roberto@unbit.it, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] cgroup: block device i/o bandwidth controller
Date: Sat, 24 May 2008 18:56:54 +0200
Message-Id: <1211648217-13361-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm resending an updated version of the cgroup I/O bandwidth controller
that I wrote some months ago (http://lwn.net/Articles/265944), since
someone asked me recently.

The goal of this patchset is to implement a block device I/O bandwidth
controller using cgroups.

Detailed informations about design, its goal and usage are described in
the documentation.

Review, comments and feedbacks are welcome.

-Andrea
