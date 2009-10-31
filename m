Return-Path: <linux-kernel-owner+w=401wt.eu-S933198AbZJaTKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbZJaTKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 15:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933183AbZJaTKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 15:10:46 -0400
Received: from kroah.org ([198.145.64.141]:41176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134AbZJaTKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 15:10:45 -0400
Date: Sat, 31 Oct 2009 12:10:40 -0700
From: Greg KH <greg@kroah.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/7] kfifo: new API v0.6
Message-ID: <20091031191040.GB15121@kroah.com>
References: <1256391194.7362.7.camel@wall-e>
 <20091030222447.GA11671@kroah.com>
 <1256975440.32191.2.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256975440.32191.2.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Sat, Oct 31, 2009 at 08:50:40AM +0100, Stefani Seibold wrote:
> Hi Greg,
> 
> thanks for your support. But i don't think so. The current patch should
> fix all drivers which are use the old kfifo. If there are problems i
> will contact you ;-)

I realize it fixes all current usages of kfifo, which is why I offered
to take it through my driver-core tree so it has a path into Linus's
tree for the 2.6.33 kernel release.  Unless you are submitting it some
other way?

thanks,

greg k-h
