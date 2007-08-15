Return-Path: <linux-kernel-owner+w=401wt.eu-S1763294AbXHOAb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763294AbXHOAb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbXHOAbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:31:15 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:58040 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400AbXHOAbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:31:13 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] [534/2many] MAINTAINERS - VIDEO
	FOR LINUX
From: hermann pitton <hermann-pitton@arcor.de>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
       v4l-dvb-maintainer@linuxtv.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <1a297b360708140702s20f72661w39e6bacf146cf866@mail.gmail.com>
References: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
	 <1187028910.664.11.camel@gaivota> <1187030038.10249.237.camel@localhost>
	 <1a297b360708131222t55be6fbax78a6659762a98e7e@mail.gmail.com>
	 <1187056816.10249.366.camel@localhost> <46C10E85.2070902@linuxtv.org>
	 <1187059484.10249.370.camel@localhost> <1187098031.7287.10.camel@gaivota>
	 <1a297b360708140635h3f7d00e5sa8c98a84340b8ff5@mail.gmail.com>
	 <1187099269.7287.13.camel@gaivota>
	 <1a297b360708140702s20f72661w39e6bacf146cf866@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 02:27:41 +0200
Message-Id: <1187137661.6162.3.camel@pc08.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 14.08.2007, 18:02 +0400 schrieb Manu Abraham:
> On 8/14/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> >
> > >
> > > > F: drivers/media/*
> > >
> > >
> > > This is NOT OK !
> >
> > This IS ok. You just need to read the definition of the 'F' tag:
> >
> > F: Files and directories with wildcard patterns.
> >    A trailing slash includes all files and subdirectory files.
> >         F:      drivers/net/    all files in and below drivers/net
> >         F:      drivers/net/*   all files in drivers/net, but not below
> >         F:      */net/*         all files in "any top level directory"/net
> >    One pattern per line.  Multiple F: lines acceptable.
> >
> > This tag just includes Kconfig and Makefile.
> 
> 
> Just as much as you state that, the reverse is as well true for
> Kconfig and Makefile.
> 

Please explain what you still want and why.

After two almost wasted years, you should be able to do so.


