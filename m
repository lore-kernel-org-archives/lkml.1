Return-Path: <linux-kernel-owner+w=401wt.eu-S1765353AbXGNWMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765353AbXGNWMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 18:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763593AbXGNWMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 18:12:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47504 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762102AbXGNWMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 18:12:42 -0400
Date: Sun, 15 Jul 2007 00:13:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Geode GX framebuffer driver: Arcom vs. AMD
Message-ID: <20070714221356.GA15254@uranus.ravnborg.org>
References: <76366b180707141201u14585c2eyeb58f0b7b279ea1b@mail.gmail.com> <20070714191854.GD13823@uranus.ravnborg.org> <76366b180707141357g39eca7a8p706f39a7a515719a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76366b180707141357g39eca7a8p706f39a7a515719a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 04:57:11PM -0400, Andrew Paprocki wrote:
> 
> >-> There seems to be a _lot_ of specific defines in lib/cimarron - I wonder
> >   if this is the way used in the rest of the kernel?
> 
> Which defines are you referring to? I know there are a few 'settings'
> which are modified by changing #defines in one of the .h files. I'm
> assuming that those would be moved to Kconfig values if this was ever
> in the kernel.
Sorry - meant to say declarations.
But I guess this is just typical grapicah chipset constants for the
various settings.

	Sam
