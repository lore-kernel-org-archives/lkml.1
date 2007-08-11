Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbXHKGHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbXHKGHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 02:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbXHKGGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 02:06:48 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37728 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752049AbXHKGGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 02:06:41 -0400
Message-ID: <386812375.01806@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070811060202.690651223@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 14:02:02 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] writeback dirty inodes fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Now the patches are simplified and rebased to 2.6.23-rc2-mm2.

The following two patches should be put immediately after
writeback-fix-periodic-superblock-dirty-inode-flushing.patch:

 writeback: fix time ordering of the per superblock inode lists 8   
 writeback: fix ntfs with sb_has_dirty_inodes()                     

Thank you,
Fengguang
