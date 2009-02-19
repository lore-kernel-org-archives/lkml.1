Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbZBSVD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbZBSVD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZBSVDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:03:19 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:54588 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbZBSVDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:03:18 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 16:03:18 EST
Date: Thu, 19 Feb 2009 21:58:13 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alex Buell <alex.buell@munted.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: [PATCH] Incorrect URL given in drivers/video/Kconfig
In-Reply-To: <20090117233539.07abdfc2@lithium.local.net>
Message-ID: <Pine.LNX.4.64.0902192156560.2221@anakin>
References: <20090117233539.07abdfc2@lithium.local.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2009, Alex Buell wrote:
> --- linux/drivers/video/Kconfig.old	2009-01-17 23:31:53.831765544 +0000
> +++ linux/drivers/video/Kconfig	2009-01-17 23:32:40.049414838 +0000
> @@ -41,7 +41,7 @@
>  	  You need an utility program called fbset to make full use of frame
>  	  buffer devices. Please read <file:Documentation/fb/framebuffer.txt>
>  	  and the Framebuffer-HOWTO at
> -	  <http://www.tahallah.demon.co.uk/programming/prog.html> for more
> +	  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.2.html> for more

Which got obsoleted by
http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.3.html in the mean
time...

Any chance we could have a permanent link here?

>  	  information.
>  
>  	  Say Y here and to the driver for your graphics board below if you

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
