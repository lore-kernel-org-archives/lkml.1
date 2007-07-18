Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXGRDEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXGRDEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 23:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXGRDD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 23:03:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:21020 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbXGRDD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 23:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i9oQrKIYcKE0yyVGS+77+RDWEx1OmT9Qk/20BVKB80EOwMvdRB0QUj85qoYKk4pWiLGd4PLlBXdnGmcbmOZ6Sw0WG/CQ9q84kDwFyNiu5FOQri5lDxhItBu3eLGPBQvLfPsYWRfbeO3jDAkAbJTf4ojzIpAXSX7LMM73dN74dSc=
Message-ID: <a8e1da0707172003o140cadf9h91dcba4ec2c449cf@mail.gmail.com>
Date: Wed, 18 Jul 2007 03:03:56 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH][DOC]hpet.txt broken link fix
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46946201.9030803@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070711112535.GA13395@darkstar.te-china.tietoenator.com>
	 <46946201.9030803@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/11/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Dave Young wrote:
> > Hi, randy
> >
> > how about remove the spec links in the header files as well.
> >
> > Subject:
> > Remove document links in hpet header files.
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> Agreed.  Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>
>
> > ---
> > include/asm-i386/hpet.h   |    6 ------
> > include/asm-x86_64/hpet.h |    6 ------
> > 2 files changed, 12 deletions(-)
> >
> > diff -pur linux/include/asm-i386/hpet.h linux.new/include/asm-i386/hpet.h
> > --- linux/include/asm-i386/hpet.h     2007-07-11 11:15:42.000000000 +0000
> > +++ linux.new/include/asm-i386/hpet.h 2007-07-11 11:16:51.000000000 +0000
> > @@ -28,12 +28,6 @@
> >
> >  #include <linux/timex.h>
> >
> > -/*
> > - * Documentation on HPET can be found at:
> > - *      http://www.intel.com/ial/home/sp/pcmmspec.htm
> > - *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
> > - */
> > -
> >  #define HPET_MMAP_SIZE       1024
> >
> >  #define HPET_ID              0x000
> > diff -pur linux/include/asm-x86_64/hpet.h linux.new/include/asm-x86_64/hpet.h
> > --- linux/include/asm-x86_64/hpet.h   2007-07-11 11:16:07.000000000 +0000
> > +++ linux.new/include/asm-x86_64/hpet.h       2007-07-11 11:17:03.000000000 +0000
> > @@ -1,12 +1,6 @@
> >  #ifndef _ASM_X8664_HPET_H
> >  #define _ASM_X8664_HPET_H 1
> >
> > -/*
> > - * Documentation on HPET can be found at:
> > - *      http://www.intel.com/ial/home/sp/pcmmspec.htm
> > - *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
> > - */
> > -
> >  #define HPET_MMAP_SIZE       1024
> >
> >  #define HPET_ID              0x000
>
>
Hi,
This patch seems to be missed.

Regards
dave
