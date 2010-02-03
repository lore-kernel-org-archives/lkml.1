Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab0BCX4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:56:16 -0500
Received: from kroah.org ([198.145.64.141]:53612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab0BCX4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:56:15 -0500
Date: Wed, 3 Feb 2010 15:47:24 -0800
From: Greg KH <greg@kroah.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [stable] [PATCH 0/4] devmem and readahead fixes for 2.6.33
Message-ID: <20100203234724.GA23902@kroah.com>
References: <20100122045914.993668874@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122045914.993668874@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 12:59:14PM +0800, Wu Fengguang wrote:
> Greg,
> 
> The first two patches are on devmem. 2.6.32 also needs fixing, however
> the patches can only apply cleanly to 2.6.33. I can do backporting if
> necessary.
> 
> 	[PATCH 1/4] devmem: check vmalloc address on kmem read/write
> 	[PATCH 2/4] devmem: fix kmem write bug on memory holes

As these patches are now in Linus's tree, can you provide backports for
them and send them to the stable@kernel.org address?

thanks,

greg k-h
