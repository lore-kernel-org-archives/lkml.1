Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab0BYQLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:11:21 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:58127 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932726Ab0BYQLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:11:19 -0500
Date: Thu, 25 Feb 2010 16:12:24 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: phillip.lougher@gmail.com
Subject: [PATCH 0/3] Squashfs: Some trivial tidy-ups and tweaks
Message-ID: <4b86a168.dvCdsR29XktjK2v6%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a couple of trivial fixes to be added to the LZMA stuff
for the merge window ...

Phillip Lougher (3):
      Squashfs: get rid of obsolete variable in struct squashfs_sb_info
      Squashfs: get rid of obsolete definition in header file
      Squashfs: update Kconfig help to include lzma support

Thanks

Phillip

