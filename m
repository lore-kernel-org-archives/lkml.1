Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbXCYRDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbXCYRDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 13:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXCYRDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 13:03:41 -0400
Received: from verein.lst.de ([213.95.11.210]:35653 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXCYRDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 13:03:40 -0400
Date: Sun, 25 Mar 2007 19:03:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make remove_inode_dquot_ref() static
Message-ID: <20070325170330.GA2224@lst.de>
References: <20070325145825.GK16477@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325145825.GK16477@stusta.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 04:58:25PM +0200, Adrian Bunk wrote:
> remove_inode_dquot_ref() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Acked-by: Jan Kara <jack@suse.cz>

Looks good to me.

