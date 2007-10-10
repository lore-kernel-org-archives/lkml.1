Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXJJTtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXJJTtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXJJTtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:49:10 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36200 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbXJJTtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:49:07 -0400
X-Originating-Ip: 99.236.101.138
Date: Wed, 10 Oct 2007 15:43:54 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: linux-kernel@vger.kernel.org
Subject: Re: [matthew@wil.cx: Re: [parisc-linux] parisc arch makefile clean-up
 needed [Was: cleaning up "make headers_install" for various architectures]]
In-Reply-To: <20071010191538.GF2730@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0710101542350.12230@localhost.localdomain>
References: <20071010191538.GF2730@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.19, required 5, autolearn=not spam,
	ADDRESS_IN_SUBJECT 0.53, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	INIT_RECVD_OUR_AUTH -20.00, TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, Matthew Wilcox wrote:

>
> Sam mipslet 'parisc-linux' in the first mail ... so i replied to the
> second mail ... without checking l-k was still cc'd.
>
> ----- Forwarded message from Matthew Wilcox <matthew@wil.cx> -----
>
> From: Matthew Wilcox <matthew@wil.cx>
> To: Sam Ravnborg <sam@ravnborg.org>
> Cc: parisc-linux@lists.parisc-linux.org
> Subject: Re: [parisc-linux] parisc arch makefile clean-up needed [Was:
> 	cleaning up "make headers_install" for various architectures]
>
> On Wed, Oct 10, 2007 at 08:42:25PM +0200, Sam Ravnborg wrote:
> > parisc arch Makefile needs some love and care...
> >
> > The logic selecting CROSS_COMPILE seems fishy and wrong -
> > the error reported by rday is obvious in this respect.
>
> He doesn't have a compiler installed that can target parisc.  It
> doesn't seem obvious to me that this should work.

are you claiming that installing arch-specific kernel headers should,
in fact, require an appropriate cross compiler?  i wouldn't have
thought so, but i'm willing to be corrected.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
