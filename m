Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbXGQRNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbXGQRNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbXGQRNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:13:16 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35841 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754779AbXGQRNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:13:16 -0400
Date: Tue, 17 Jul 2007 19:12:36 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mike@pikeaero.com, linux-kernel@vger.kernel.org
Subject: Re: maintainer: parport drivers
Message-ID: <20070717171236.GG3801@stusta.de>
References: <1184688556.711.8.camel@jake> <20070717095815.ae811965.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070717095815.ae811965.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 09:58:15AM -0700, Randy Dunlap wrote:
> On Tue, 17 Jul 2007 12:09:16 -0400 Mike Sharkey wrote:
> 
> > Hello,
> > 
> > I understand there are currently no active maintainers of parport and
> > friends - unless that has changed recently. 
> > 
> > We are heavy users of parport devices, and so I am offering to begin
> > maintaining the parport drivers. I have spent some time studying the
> > drivers closely, and I've read Love's book linux kernel development, so
> > I think I'm just about ready for this.
> > 
> > My question is; what are some of the outstanding issues with parport
> > which people would like to see addressed?
> 
> There are probably others, but "Advanced Search" at
> bugzilla.kernel.org finds these 4 bug reports:
>...

You don't need an advanced search.

There's a component Drivers/Parallel in the kernel Bugzilla that 
contains a superset of the bugs from your search.

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

