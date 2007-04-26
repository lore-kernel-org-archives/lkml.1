Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbXDZRNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbXDZRNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbXDZRMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:12:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35450 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754860AbXDZRMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:12:31 -0400
Date: Thu, 26 Apr 2007 19:12:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rene Herman <rene.herman@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070426171242.GP3468@stusta.de>
References: <462C7D74.60003@gmail.com> <1177327476.17026.75.camel@localhost.localdomain> <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain> <462CA764.5080401@gmail.com> <20070425181856.42fcfeb4.akpm@linux-foundation.org> <463081E5.5010306@gmail.com> <20070426135426.GM3468@stusta.de> <20070426084143.1d973c71.randy.dunlap@oracle.com> <20070426155205.GN3468@stusta.de> <20070426094427.6f5bfc4c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070426094427.6f5bfc4c.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 09:44:27AM -0700, Randy Dunlap wrote:
>...
> > IMHO the default should be that users report problems with distribution 
> > kernels to their distribution and problems with ftp.kernel.org kernels 
> > to either linux-kernel or the kernel Bugzilla.
> 
> s/linux-kernel/the appropriate mailing list/ please :)
>...

Yes, in an ideal world.

But a user reporting an Oops might not even know where the problem lies.

And a user reporting a networking bug to linux-kernel hasn't really done 
any mistake. Forwarding bugs to the right people (as Andrew does and I'm 
sometimes doing) is actually an easy part of bug handling.

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

