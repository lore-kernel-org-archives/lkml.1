Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbZDAIsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbZDAIsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761229AbZDAIsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:48:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:56333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbZDAIsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:48:18 -0400
Date: Wed, 1 Apr 2009 10:48:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Ali Gholami Rudi <ali@rudi.ir>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       jack@atrey.karlin.mff.cuni.cz, trivial@kernel.org
Subject: Re: [PATCH][TRIVIAL] ext2: fix a typo in ext2.h
In-Reply-To: <20090330121927.GA2237@lilem.mirepesht>
Message-ID: <alpine.LNX.2.00.0904011047570.2777@wotan.suse.de>
References: <20090330121927.GA2237@lilem.mirepesht>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Ali Gholami Rudi wrote:

> Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
> ---
>  fs/ext2/ext2.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 3203042..6888b2d 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -27,7 +27,7 @@ struct ext2_inode_info {
>  	/*
>  	 * i_block_group is the number of the block group which contains
>  	 * this file's inode.  Constant across the lifetime of the inode,
> -	 * it is ued for making block allocation decisions - we try to
> +	 * it is used for making block allocation decisions - we try to
>  	 * place a file's data blocks near its inode block, and new inodes
>  	 * near to their parent directory's inode.
>  	 */

Applied to trivial tree, thanks Ali.

-- 
Jiri Kosina
SUSE Labs
