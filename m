Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0B1FlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 00:41:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:43322 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab0B1FlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 00:41:10 -0500
Date: Sun, 28 Feb 2010 16:41:01 +1100
From: Neil Brown <neilb@suse.de>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, Sandeep K Sinha <sandeepksinha@gmail.com>,
       Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
Subject: Re: [PATCH 41/66] drivers/md/linear.h: Checkpatch cleanup
Message-ID: <20100228164101.67f464c1@notabene.brown>
In-Reply-To: <1267289508-31031-42-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	<1267289508-31031-42-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 17:51:22 +0100
Andrea Gelmini <andrea.gelmini@gelma.net> wrote:

> drivers/md/linear.h:12: ERROR: open brace '{' following struct go on the same line

Thanks, but no thanks.
This just doesn't need cleaning up.

NeilBrown

> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  drivers/md/linear.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/linear.h b/drivers/md/linear.h
> index 0ce29b6..3860fd8 100644
> --- a/drivers/md/linear.h
> +++ b/drivers/md/linear.h
> @@ -8,8 +8,7 @@ struct dev_info {
>  
>  typedef struct dev_info dev_info_t;
>  
> -struct linear_private_data
> -{
> +struct linear_private_data {
>  	sector_t		array_sectors;
>  	dev_info_t		disks[0];
>  	struct rcu_head		rcu;

