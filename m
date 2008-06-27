Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbYF0FFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbYF0FFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYF0FFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:05:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56562 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYF0FFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:05:40 -0400
Date: Thu, 26 Jun 2008 22:01:01 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Deti Fliegl <deti@fliegl.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, jaswinder@infradead.org
Subject: Re: [PATCH] dabusb: use request_firmware()
Message-ID: <20080627050101.GB8362@kroah.com>
References: <1214219201.27974.21.camel@shinybook.infradead.org> <20080623112004.GA26516@infradead.org> <1214221558.27974.33.camel@shinybook.infradead.org> <20080626155517.GD22025@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626155517.GD22025@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 06:55:18PM +0300, Adrian Bunk wrote:
> On Mon, Jun 23, 2008 at 12:45:58PM +0100, David Woodhouse wrote:
> >...
> > What was the final conclusion on the need to add 'select FW_LOADER'?
> > Is that going to go away, too?
> >...
> 
> Greg, you have my "always enable FW_LOADER unless EMBEDDED=y" patch 
> queued for 2.6.27?

Yes, it is in my to-apply queue, I hope to get through it tomorrow, it
is planned to go into 2.6.27.

thanks,

greg k-h
