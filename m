Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZAIUhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZAIUhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZAIUhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:37:24 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:57044 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZAIUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:37:23 -0500
Date: Fri, 9 Jan 2009 12:37:14 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Richard Purdie <rpurdie@rpsys.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] LED updates for 2.6.29
In-Reply-To: <1231500186.5317.9.camel@dax.rpnet.com>
Message-ID: <Pine.LNX.4.64.0901091231310.22972@t2.domain.actdsltmp>
References: <1231500186.5317.9.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009, Richard Purdie wrote:
> for the LED tree updates for 2.6.29. This includes some new drivers,
> bugfixes and a core improvement resulting in nicer code.
>

Any chance of these patches getting accepted?  They've been going back and
forth for months now.

[v2,1/4] leds: Support OpenFirmware led bindings
http://patchwork.ozlabs.org/patch/13581/

[v2,2/4] leds: Add option to have GPIO LEDs start on
http://patchwork.ozlabs.org/patch/13580/

[v2,3/4] leds: Let GPIO LEDs keep their current state
http://patchwork.ozlabs.org/patch/13583/

[v2,4/4] leds: Use tristate property in platform data
http://patchwork.ozlabs.org/patch/13584/
