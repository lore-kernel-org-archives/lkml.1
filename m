Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbXDHN62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbXDHN62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 09:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXDHN62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 09:58:28 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4053 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXDHN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 09:58:28 -0400
Date: Sun, 8 Apr 2007 14:58:20 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
       MarekVa@ucw.cz
Subject: Re: [PATCH 29/90] ARM: OMAP: Palm Tungsten|T support
Message-ID: <20070408135820.GA20065@flint.arm.linux.org.uk>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
	MarekVa@ucw.cz
References: <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <20070406120923.GB3866@ucw.cz> <20070408120740.GC5431@flint.arm.linux.org.uk> <20070408121238.GB4310@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070408121238.GB4310@ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 12:12:39PM +0000, Pavel Machek wrote:
> Hi!
> 
> > > > From: =?utf-8?q?Marek_Va=C5=A1ut?= <marek.vasut@gmail.com>
> > > 
> > > EEk.
> > > 
> > > > Signed-off-by: Marek Vašut <marek.vasut@gmail.com>
> > > 
> > > Eek2.
> > 
> > As I see it, that eek2 is correct UTF-8, and since the body charset was
> > utf-8 I don't see this as a problem.
> 
> I do not think eek2 is correct utf-8. It seems to short for that. (It
> should be s with v over it.

Which is precisely what I see when viewing the message in an entirely
utf-8 based environment using mutt, whether that be the original message,
your message, my reply to your message, your subsequent reply, or even
while composing this reply.

However, on my VT console, the š displays as an inverse ? since it's
missing the correct glyph in its font - maybe that's the problem you're
seeing?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
