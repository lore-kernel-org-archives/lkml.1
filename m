Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYFZP5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYFZP5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbYFZP52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:57:28 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36639 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757179AbYFZP51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:57:27 -0400
Date: Thu, 26 Jun 2008 18:55:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>, Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>, Deti Fliegl <deti@fliegl.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, jaswinder@infradead.org
Subject: Re: [PATCH] dabusb: use request_firmware()
Message-ID: <20080626155517.GD22025@cs181140183.pp.htv.fi>
References: <1214219201.27974.21.camel@shinybook.infradead.org> <20080623112004.GA26516@infradead.org> <1214221558.27974.33.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1214221558.27974.33.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 12:45:58PM +0100, David Woodhouse wrote:
>...
> What was the final conclusion on the need to add 'select FW_LOADER'?
> Is that going to go away, too?
>...

Greg, you have my "always enable FW_LOADER unless EMBEDDED=y" patch 
queued for 2.6.27?

> dwmw2

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

