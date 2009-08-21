Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbZHURwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbZHURwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZHURwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:52:05 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:39896 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695AbZHURwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:52:04 -0400
Subject: Re: [PATCH 15/17] nfs: Remove reference to generic_osync_inode
 from a comment
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <1250875447-15622-16-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	 <1250875447-15622-16-git-send-email-jack@suse.cz>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 13:52:00 -0400
Message-Id: <1250877120.27154.11.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 1 sum rcpts/h 8 sum msgs/h 1 total rcpts 1157 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 8D71C4EF95D62507B644A2C6F7127438F248FE0F
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 161 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 19:24 +0200, Jan Kara wrote:
> generic_file_direct_write() no longer calls generic_osync_inode() so remove the
> comment.

Thanks. I've applied it to the nfs-for-2.6.32 branch.

Cheers
  Trond

