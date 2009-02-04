Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZBDIMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZBDIMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZBDIMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:12:31 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:51122 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZBDIMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:12:30 -0500
Date: Wed, 4 Feb 2009 09:12:27 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Balaji Rao <balajirrao@openmoko.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: =?UTF-8?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: build issue #587 for v2.6.29-rc2-13-gf3b8436 :_set_irq_handler"
 [drivers/mfd/pcf50633-core.ko] undefined!
In-Reply-To: <20090122173020.GI3171@fedora.yogi>
Message-ID: <Pine.LNX.4.64.0902040910340.16785@anakin>
References: <200901221812.20702.toralf.foerster@gmx.de> <20090122173020.GI3171@fedora.yogi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Balaji Rao wrote:
> On Thu, Jan 22, 2009 at 06:12:16PM +0100, Toralf Förster wrote:
> > 
> > -- 
> > MfG/Sincerely
> > 
> > Toralf Förster
> > pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
> > 
> 
> Content-Description: Toralf Förster <tfoerste@n22.n22_domain>: build issue #587 for v2.6.29-rc2-13-gf3b8436 :
> > Date: Thu, 22 Jan 2009 18:10:21 +0100
> > From: Toralf F�rster <tfoerste@n22.n22_domain>
> > To: tfoerste@n22.n22_domain
> > Subject: build issue #587 for v2.6.29-rc2-13-gf3b8436 :
> > 
> > Hello,
> > 
> > the build (.config attached) failed, make ends with :
> > ...
> 
> Hi,
> 
> This is known for more than two weeks. Fixes in various forms have been
> sent on this list, but somehow it isn't making it to the destination..
> 
> Stephen has asked Linus to pull Samuel's tree (which has the fix). Let's
> hope Linus pulls it soon..

Any chance this will happen soon?

I'd like to see the m68k build results on
http://kisskb.ellerman.id.au/kisskb/matrix/ turn green again :-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
