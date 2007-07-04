Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbXGDLKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbXGDLKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759206AbXGDLIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:08:17 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:57172 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759983AbXGDLIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:08:05 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       David Teigland <david.teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 04 Jul 2007 16:37:01 +0530
Message-Id: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH -mm 0/3] configfs: Miscellaneous cleanups
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[0/3] configfs: Miscellaneous cleanups

Simple cleanups for configfs (plus DLM and OCFS2, wherever applicable).
This is diffed against 2.6.22-rc6-mm1.

[1/3] configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h
[2/3] configfs+dlm+ocfs2: Convert subsystem semaphore to mutex
[3/3] configfs+dlm: Rename config_group_find_obj and state semantics clearly

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Satyam
