Return-Path: <linux-kernel-owner+w=401wt.eu-S1030753AbXBOT1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030753AbXBOT1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030756AbXBOT1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:27:39 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58477 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030753AbXBOT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:27:39 -0500
Date: Thu, 15 Feb 2007 20:27:37 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: v j <vj.linux@gmail.com>
cc: Theodore Tso <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
Message-ID: <Pine.LNX.4.62.0702152025410.7391@pademelon.sonytel.be>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
 <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
 <20070215165339.GB5285@thunk.org> <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, v j wrote:
> So far I have heard nothing but, "if you don't contribute, screw you."
> All this is fine. Just say so. Make it black and white. Make it
> perfectly clear what is and isn't legal. If we can't load proprietary

What's legal depends on the law. What's moral depends on...

> modules, then so be it. It will help everybody if this is out in the
> clear, instead of resorting to stupid half measures like
> EXPORT_SYMBOL_GPL.

Personally, I see no real difference between EXPORT_SYMBOL and
EXPORT_SYMBOL_GPL.
If you derive from GPL'ed code, your code is a derived work.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
