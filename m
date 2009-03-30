Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZC3MUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZC3MUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZC3MUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:20:25 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34535 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZC3MUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=p+CxP3plNk44u6qYDd0Q4t6PRT+xGZxmw05l9Hi/zIlzNDbpewGKuQ1zxu/URvbozr
         TqScRoix3ZfKybk1ABvl2xRYsFq5hbrIikJb/++6ZheK/xCHl9OG/gn4nrcZmZR57qSr
         OdQqbEUXNvrQcRNjc/z7xF8UsDpIxeE55D/h0=
Date: Mon, 30 Mar 2009 16:49:27 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][TRIVIAL] ext2: fix a typo in ext2.h
Message-ID: <20090330121927.GA2237@lilem.mirepesht>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-27)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
---
 fs/ext2/ext2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 3203042..6888b2d 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -27,7 +27,7 @@ struct ext2_inode_info {
 	/*
 	 * i_block_group is the number of the block group which contains
 	 * this file's inode.  Constant across the lifetime of the inode,
-	 * it is ued for making block allocation decisions - we try to
+	 * it is used for making block allocation decisions - we try to
 	 * place a file's data blocks near its inode block, and new inodes
 	 * near to their parent directory's inode.
 	 */
