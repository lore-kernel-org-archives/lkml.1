Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbXJWQwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbXJWQwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXJWQwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:52:13 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:33643 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXJWQwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:52:12 -0400
Date: Tue, 23 Oct 2007 18:52:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
cc: Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Crispin Cowan <crispin@crispincowan.com>, linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
In-Reply-To: <20071022035954.GA30991@kroah.com>
Message-ID: <Pine.LNX.4.64.0710231850380.15765@anakin>
References: <200710220224.l9M2Og5t020815@sapphire.spiritone.com>
 <20071022035954.GA30991@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007, Greg KH wrote:
> On Sun, Oct 21, 2007 at 07:24:42PM -0700, Thomas Fricaccia wrote:
> > As Sarbanes-Oxley and
> > other regulatory laws require these customers to use "standard
> > kernels", the result is a rather dreary form of vendor lock-in, where the
> > security framework is coupled to the distribution.
> 
> Wait, what?
> 
> Since when does Sarbanes-Oxley decree that a company must use a
> "standard kernel"?  And just exactly what defines such "standard
> kernel"?  Can you point out where in that bill it requires such a thing?

Simple, these days Sarbanes-Oxley is the default argument behind anything being
pushed down your throat in a company.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
