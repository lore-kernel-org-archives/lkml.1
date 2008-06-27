Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbYF0MjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbYF0MjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbYF0Miv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:38:51 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58165 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYF0Miu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:38:50 -0400
Date: Fri, 27 Jun 2008 15:36:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Deti Fliegl <deti@fliegl.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, jaswinder@infradead.org
Subject: Re: [PATCH] dabusb: use request_firmware()
Message-ID: <20080627123636.GC18644@cs181140183.pp.htv.fi>
References: <1214219201.27974.21.camel@shinybook.infradead.org> <20080623112004.GA26516@infradead.org> <1214221558.27974.33.camel@shinybook.infradead.org> <20080626155517.GD22025@cs181140183.pp.htv.fi> <20080627050101.GB8362@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080627050101.GB8362@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:01:01PM -0700, Greg KH wrote:
> On Thu, Jun 26, 2008 at 06:55:18PM +0300, Adrian Bunk wrote:
> > On Mon, Jun 23, 2008 at 12:45:58PM +0100, David Woodhouse wrote:
> > >...
> > > What was the final conclusion on the need to add 'select FW_LOADER'?
> > > Is that going to go away, too?
> > >...
> > 
> > Greg, you have my "always enable FW_LOADER unless EMBEDDED=y" patch 
> > queued for 2.6.27?
> 
> Yes, it is in my to-apply queue, I hope to get through it tomorrow, it
> is planned to go into 2.6.27.

Thanks.

David, you do not have to add the select's.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

