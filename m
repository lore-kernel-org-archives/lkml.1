Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbYJTVhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbYJTVhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbYJTVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:36:30 -0400
Received: from kroah.org ([198.145.64.141]:37450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753584AbYJTVg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:36:28 -0400
Date: Mon, 20 Oct 2008 13:57:34 -0700
From: Greg KH <greg@kroah.com>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: staging: SLICOSS: remove duplicated #include's
Message-ID: <20081020205734.GB24476@kroah.com>
References: <20081018113734.61B1.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018113734.61B1.WEIYI.HUANG@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 11:52:11AM +0800, Huang Weiyi wrote:
> Removed duplicated #include's in drivers/staging/slicoss/slicoss.c.
>   linux/delay.h
>   linux/etherdevice.h
>   linux/init.h
>   linux/netdevice.h
>   linux/pci.h
>   linux/skbuff.h
>   linux/slab.h
>   linux/string.h

Do you have some script that you run to catch all of these?

thanks,

greg k-h
