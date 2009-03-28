Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZC1PvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZC1PvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 11:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZC1PvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 11:51:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:45342 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZC1PvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 11:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DLLVM82SUpSJf3x2UrNGLHpQzXIJ4P/vB/F9nqgsqM0PXidHLlEfjKL1OUzX4qbMOw
         gBjagdIQGcXDI0Q2tZ9+EsSxuQcxJaaHv+WKQyLa89x/lVBy4UAhrbo6FckTR4jzabvk
         q/CMBnV8Dwa+jHSQjS5sXyYIIlVZA7xlzntzA=
Date: Sat, 28 Mar 2009 18:58:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090328155837.GA3503@x200.localdomain>
References: <1238251730.2526.2.camel@ht.satnam> <20090328150746.GA3268@x200.localdomain> <20090328155549.47c9cdc5@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328155549.47c9cdc5@the-village.bc.nu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 03:55:49PM +0000, Alan Cox wrote:
> > kenel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-Xmas.git x86/core
> > > 
> > > Jaswinder Singh Rajput (49):
> > >       x86: process_32.c include inverse Xmas tree effect
> > 
> > What the heck is this?
> 
> Does inverse christmas tree effect not translate well. It could perhaps
> have been more clearly explained.
> 
> Getting the includes under control is a good thing and saves everyone
> time.

Moving #includes up and down is not getting them under control.
