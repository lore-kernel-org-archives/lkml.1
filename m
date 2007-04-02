Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXDBO5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXDBO5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXDBO5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:57:03 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40141 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbXDBO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:57:01 -0400
Date: Mon, 2 Apr 2007 10:53:00 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Antoine Martin <antoine@nagafix.co.uk>,
       Blaisorblade <blaisorblade@yahoo.it>, devzero@web.de,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel release ?
Message-ID: <20070402145300.GA6179@c2.user-mode-linux.org>
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it> <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org> <4610D937.20002@nagafix.co.uk> <Pine.LNX.4.64.0704021318410.1276@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704021318410.1276@anakin>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 01:22:00PM +0200, Geert Uytterhoeven wrote:
> There are patches floating around for a UML frame buffer device.
> Gerd Kraxel^H^H^H^H^H^HHoffmann did one using plain X11, which worked
> great when I gave it a try.
> 
> I suggest taking a look at Gerd's patches. IIRC, he posted them to lkml
> last year.

I have Gerd's patch sitting in my tree, but it's never really worked
for me, so I haven't pushed it.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
