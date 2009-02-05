Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbZBEPyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbZBEPyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZBEPxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:53:52 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:50892 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbZBEPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:53:52 -0500
Date: Thu, 5 Feb 2009 16:53:50 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, uClinux list <uclinux-dev@uclinux.org>
Subject: Re: Fix support for console port other than ttyS0 on mcf.c
In-Reply-To: <20090205152751.GL26064@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0902051652080.5127@anakin>
References: <20090204201518.GH26064@csclub.uwaterloo.ca>
 <20090204202009.GI26064@csclub.uwaterloo.ca> <Pine.LNX.4.64.0902042200340.25136@anakin>
 <20090205152751.GL26064@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Lennart Sorensen wrote:
> On Wed, Feb 04, 2009 at 10:00:58PM +0100, Geert Uytterhoeven wrote:
> > On Wed, 4 Feb 2009, Lennart Sorensen wrote:
> > > Perhaps CCing linux-m68k@lists.linux-m68k.org would be a good idea.
> > 
> > Thanks, but this is a uClinux driver.
> 
> This is a patch against Linus's current tree.  How is that a uClinux
> driver?  I am using a build of yesterday's git tree from Linus on a
> 5271evb board and this fixes the console port with it.  I have no user
> space yet, so whatever does uClinux have to do with anything?

linux-m68k@lists.linux-m68k.org handles m68k (with MMU) only.
uclinux-dev@uclinux.org handles m68knommu.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
