Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYHYLy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYHYLy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYHYLyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:54:19 -0400
Received: from ns.ariel-networks.com ([124.39.57.10]:35118 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYHYLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:54:18 -0400
To: linux-kernel@vger.kernel.org
Subject: Question : ext2 compatibility feature mechanism
Message-Id: <20080825115417.E78F797800C@ns.ariel-networks.com>
Date: Mon, 25 Aug 2008 20:54:17 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroyasu Ohyama.

I develop software that write format of ext2 to block device for enjoyment like 'mke2fs'.

To develop this, I've read the book of 'Understanding Linux Kernel',  linux kernel document which is Documentation/filesystems/ext2.txt and source code of ext2fs which is 'http://e2fsprogs.sourceforge.net/'.

But I couldn't obtain some infomation about ext2 filesystem.
That is compatibility feature mechanism which is supported by ext2 revision 1.

Of course, the device file that is created by my program could be mounted on linux. But I really want to know these mechanism.
To be more specific, I wnat to know what will happen, if I operate bitmap of super block parameter of s_feature_compat, s_feature_incompat and s_feature_ro_compat.

Could you please give me the documents that is written about ext2 filesystem at length, especially compatibility feature mechanism.

Thank you.

