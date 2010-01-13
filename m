Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307Ab0AMUU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab0AMUU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291Ab0AMUUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:20:22 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:39210 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756255Ab0AMUUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:20:11 -0500
Date: Wed, 13 Jan 2010 20:18:50 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: phillip.lougher@gmail.com
Subject: [PATCH V3 0/2] Squashfs: Add support for LZMA compressed
 filesystems
Message-ID: <4b4e2aaa.CMX8OUQixp12onkQ%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is a respin of two of my Squashfs LZMA decompression support patches
(in linux-next).  These patches have been updated to accommodate the
addition of the lzo decompressor to the mainline kernel.

lzma: Make lzma available to non initramfs/initrd code
lzma: make lzma reentrant

Changes: a new unlzo_mm.h file has been added.

Thanks

Phillip

