Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0BXAq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:46:58 -0500
Received: from kroah.org ([198.145.64.141]:59854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab0BXAq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:46:56 -0500
Date: Tue, 23 Feb 2010 16:35:42 -0800
From: Greg KH <greg@kroah.com>
To: Gordon Mitchell <gordon@dumgoyne.me.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: Fixed coding style issues
Message-ID: <20100224003542.GA12138@kroah.com>
References: <4B772E67.1030805@dumgoyne.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B772E67.1030805@dumgoyne.me.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 10:57:43PM +0000, Gordon Mitchell wrote:
> 
> commit eaf625ed89a5bbf40ef1e2740f2de6b6ac322c01
> Author: Gordon Mitchell <gordon@dumgoyne.me.uk>
> Date:   Sat Feb 13 21:09:24 2010 +0000
> 
>     Staging: rtl8187se: Apply kernel coding styles to r8180_93cx6.c
>     This patch to r8180_93cx6.c corrects errors and warnings found
>     by checkpatch.pl
>     Signed-off-by: Gordon Mitchell <gordon@dumgoyne.me.uk>
> 
> diff --git a/drivers/staging/rtl8187se/r8180_93cx6.c b/drivers/staging/rtl8187se/r8180_93cx6.c
> index 7e4711f..2a29cff 100644
> --- a/drivers/staging/rtl8187se/r8180_93cx6.c
> +++ b/drivers/staging/rtl8187se/r8180_93cx6.c
> @@ -22,13 +22,13 @@
>  
>  void eprom_cs(struct net_device *dev, short bit)
>  {
> -       if(bit)
> +       if (bit)
>                 write_nic_byte(dev, EPROM_CMD,

Hm, the tabs got converted to spaces here.  Care to try resending this
again?

thanks,

greg k-h
