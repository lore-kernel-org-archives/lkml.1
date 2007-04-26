Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbXDZWA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbXDZWA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbXDZWA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:00:58 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35769 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755073AbXDZWA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:00:57 -0400
Date: Fri, 27 Apr 2007 00:01:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Rene Herman <rene.herman@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070426220107.GA3468@stusta.de>
References: <20070425181856.42fcfeb4.akpm@linux-foundation.org> <463081E5.5010306@gmail.com> <20070426135426.GM3468@stusta.de> <20070426084143.1d973c71.randy.dunlap@oracle.com> <20070426155205.GN3468@stusta.de> <m38xcfhqp4.fsf@maximus.localdomain> <20070426194316.GY3468@stusta.de> <m3ps5qhpk4.fsf@maximus.localdomain> <20070426202436.GZ3468@stusta.de> <m3wszyst26.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m3wszyst26.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 11:51:29PM +0200, Krzysztof Halasa wrote:
> Adrian Bunk <bunk@stusta.de> writes:
> 
> > The problem with such a database would be the same as with the 
> > MAINTAINERS file: The information becomes outdated, and someone has to 
> > maintain it.
> 
> Sure, I can easily grep .../linux-current/MAINTAINERS. But I think the
> whole problem is with people who don't have current sources.

No, even MAINTAINERS in the latest sources always contains outdated 
entries and lacks information.

If you think "no current sources" is a problem that should be solved, 
the solution would simply be a link to [1].

> Krzysztof Halasa

cu
Adrian

[1] http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=MAINTAINERS;hb=HEAD

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

