Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbXHGEQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbXHGEQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 00:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXHGEQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 00:16:27 -0400
Received: from pcls6.std.com ([192.74.137.146]:38731 "EHLO TheWorld.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbXHGEQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 00:16:26 -0400
From: Alan Curry <pacman@theworld.com>
Message-Id: <200708070416.l774G3Qf728075@shell01.TheWorld.com>
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
To: matt@genesi-usa.com (Matt Sealey)
Date: Tue, 7 Aug 2007 00:16:03 -0400 (EDT)
Cc: segher@kernel.crashing.org (Segher Boessenkool), linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46B79562.9020202@genesi-usa.com> from "Matt Sealey" at Aug 06, 2007 10:40:50 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm almost sorry I spoke up...

Matt Sealey writes the following:
>
>Okay before you add to the nvramrc you also need to add probe-all to build the
>device tree first; I assumed this was common knowledge.

Maybe for experienced OpenFirmware developers; this is the first time I've
had to touch the stuff. So first I had to learn Forth. To patch the kernel
you only need to know C. (Of course I already knew C -- it's common
knowledge.)

