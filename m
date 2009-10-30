Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbZJ3WYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbZJ3WYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932986AbZJ3WYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:24:53 -0400
Received: from kroah.org ([198.145.64.141]:49434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980AbZJ3WYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:24:53 -0400
Date: Fri, 30 Oct 2009 15:24:47 -0700
From: Greg KH <greg@kroah.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/7] kfifo: new API v0.6
Message-ID: <20091030222447.GA11671@kroah.com>
References: <1256391194.7362.7.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256391194.7362.7.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 03:33:14PM +0200, Stefani Seibold wrote:
> This is a new generic kernel FIFO implementation.

<snip>

Good stuff, how is this going to get into Linus's tree for .33?  Need me
to take it through the "driver core" tree, as it seems to touch a lot of
drivers?  If so, I'll be glad to do so.

Feel free to add my:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patches touching the USB files.

thanks,

greg k-h
