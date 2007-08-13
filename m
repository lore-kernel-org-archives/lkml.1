Return-Path: <linux-kernel-owner+w=401wt.eu-S1032968AbXHMUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032968AbXHMUSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbXHMUSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:18:30 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:49502 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764261AbXHMUS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c7L3p/Ai32bGyrvEoxOcVjXMtQfZvUAfIvZAdaN1oL4rjrm/nfTzgHl7or2eCHTxpQZiYoleyK2MGxkLl49d/nK1hbjwJKo+qANK2vD82SccCvEB1dEwRsLspunD2fa8oZY5agDYpWPwA6maSUQ8ra9n5KKtDIss7rZsWyiAn1w=
Subject: Re: [PATCH] [467/2many] MAINTAINERS - SVGA HANDLING
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Martin Mares <mj@ucw.cz>, torvalds@linux-foundation.org,
       linux-video@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1187028193.10249.197.camel@localhost>
References: <46bffc09.olZ/JU6zLi5nghOY%joe@perches.com>
	 <mj+md-20070813.084046.10732.nikam@ucw.cz>
	 <1187028193.10249.197.camel@localhost>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 04:18:21 +0800
Message-Id: <1187036301.5058.5.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 11:03 -0700, Joe Perches wrote:
> > > +F:	drivers/video/svgalib.c
> > > +F:	include/linux/svga.h
> > These two are not a part of the video mode selection code, but
> > arch/i386/boot/video.S is.
> 
> SVGA HANDLING
> P:	Martin Mares
> M:	mj@ucw.cz
> L:	linux-video@atrey.karlin.mff.cuni.cz
> S:	Maintained
> F:	Documentation/svga.txt
> F:	arch/i386/boot/video.S

video.S is no more. Replaced by arch/i386/boot/video-*.c

Tony


