Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXHNOCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXHNOCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbXHNOCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:02:14 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:25178 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbXHNOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I1bZgtbapk3XQ5dQ5vyC1zWVFl5pf/WhL0dwsQ3045mhsgkeLehy8dIDE5doaQCgp6jV0Ooxwpp7egf7at5r8RgngHNIQauyEm5bgkw/OiNqsObOmRywdeNwKfZSmR/DQBH3fu6ujKk0zWJlFoJd5nEgBCu0uqzZQpQ5MUf55Wc=
Message-ID: <1a297b360708140702s20f72661w39e6bacf146cf866@mail.gmail.com>
Date: Tue, 14 Aug 2007 18:02:13 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] [534/2many] MAINTAINERS - VIDEO FOR LINUX
Cc: "Joe Perches" <joe@perches.com>, "Michael Krufky" <mkrufky@linuxtv.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <1187099269.7287.13.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
	 <1187028910.664.11.camel@gaivota>
	 <1187030038.10249.237.camel@localhost>
	 <1a297b360708131222t55be6fbax78a6659762a98e7e@mail.gmail.com>
	 <1187056816.10249.366.camel@localhost> <46C10E85.2070902@linuxtv.org>
	 <1187059484.10249.370.camel@localhost>
	 <1187098031.7287.10.camel@gaivota>
	 <1a297b360708140635h3f7d00e5sa8c98a84340b8ff5@mail.gmail.com>
	 <1187099269.7287.13.camel@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>
> >
> > > F: drivers/media/*
> >
> >
> > This is NOT OK !
>
> This IS ok. You just need to read the definition of the 'F' tag:
>
> F: Files and directories with wildcard patterns.
>    A trailing slash includes all files and subdirectory files.
>         F:      drivers/net/    all files in and below drivers/net
>         F:      drivers/net/*   all files in drivers/net, but not below
>         F:      */net/*         all files in "any top level directory"/net
>    One pattern per line.  Multiple F: lines acceptable.
>
> This tag just includes Kconfig and Makefile.


Just as much as you state that, the reverse is as well true for
Kconfig and Makefile.
