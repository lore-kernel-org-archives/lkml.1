Return-Path: <linux-kernel-owner+w=401wt.eu-S935962AbXGQThl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935962AbXGQThl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763288AbXGQThc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:37:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:13263 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbXGQThb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:37:31 -0400
Date: Tue, 17 Jul 2007 21:37:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Shawn Rutledge <shawn.t.rutledge@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: attempting to open a VT from elsewhere and take raw keyboard
 input
In-Reply-To: <d9a6586e0707170151r799ccff1gcd0a84e7f3524cd5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707172135110.27468@fbirervta.pbzchgretzou.qr>
References: <d9a6586e0707170151r799ccff1gcd0a84e7f3524cd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 17 2007 01:51, Shawn Rutledge wrote:
>
> I'm messing around with framebuffer graphics stuff and trying to write
> a keyboard driver similar to the one in X, which will allow you to
> start up the graphics system from any tty (not just a virtual
> console),

right, I can start X these days over SSH (either init5 or startx)

> find an available VT, switch to that VT,

X does that automatically ('regular' X, not considering Xdmcp or such)

> and then take input from the physically attached keyboard rather
> than necessarily

X does that too.



	Jan
-- 
