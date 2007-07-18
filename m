Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbXGRHtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbXGRHtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXGRHtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:49:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:26603 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbXGRHtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:49:17 -0400
Date: Wed, 18 Jul 2007 09:49:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Shawn Rutledge <shawn.t.rutledge@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: attempting to open a VT from elsewhere and take raw keyboard
 input
In-Reply-To: <d9a6586e0707172201m557b91fy5c356d8c98215ffa@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707180949070.27468@fbirervta.pbzchgretzou.qr>
References: <d9a6586e0707170151r799ccff1gcd0a84e7f3524cd5@mail.gmail.com> 
 <Pine.LNX.4.64.0707172135110.27468@fbirervta.pbzchgretzou.qr>
 <d9a6586e0707172201m557b91fy5c356d8c98215ffa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 17 2007 22:01, Shawn Rutledge wrote:
> Yes I know that X does it; I'm trying to write a new windowing system
> which also does that, and the question is how they did it.  I would
> have expected if I just open /dev/tty1, set raw mode, and set some
> termios flags I'd get every key press and release; and it would be my
> choice whether to use blocking or non-blocking I/O.

Why, look at the Xorg source code.


	Jan
-- 
