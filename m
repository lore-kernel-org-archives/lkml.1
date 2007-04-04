Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXDDPCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXDDPCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXDDPCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:02:32 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42690 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752625AbXDDPCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:02:31 -0400
Date: Wed, 4 Apr 2007 17:02:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Christoph Hellwig <hch@infradead.org>, Rene Herman <rene.herman@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070404150231.GE27660@stusta.de>
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org> <1175698135.5815.447.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1175698135.5815.447.camel@violet>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 04:48:55PM +0200, Marcel Holtmann wrote:
> Hi Christoph,
> 
> > > Can we have a MODULE_MAINTAINER to complement MODULE_AUTHOR?
> > 
> > #define MODULE_MAINTAINER(x) MODULE_AUTHOR(x), please.
> > MODULE_AUTHOR really has meant maintainer in practice for ages, and it's
> > the only actually relevant for users information we should store.
> 
> I agree. The actual author information belong into the files copyright
> header. The MODULE_AUTHOR should only show the current maintainer and
> its email address. However this might need some cleanup. Maybe it is
> time that we sync the MAINTAINERS file with the MODULE_AUTHOR tag.

Or even remove the MODULE_AUTHOR tag?

Even if you would spend the time for syncing the > 1600 MODULE_AUTHOR 
tags today, I don't see this happen on an ongoing basis in the future.

> Regards
> 
> Marcel

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

