Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZBOP0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZBOP0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 10:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZBOP0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 10:26:07 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:4862 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZBOP0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 10:26:06 -0500
Date: Sun, 15 Feb 2009 16:25:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <frank@f-seidel.de>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, rlove@rlove.org
Subject: Re: [PATCH] MAINTAINERS: switch hdaps to Frank Seidel
Message-ID: <20090215162558.34c38a9e@hyperion.delvare>
In-Reply-To: <49981F1B.8040302@f-seidel.de>
References: <49980A67.7030403@suse.de>
	<20090215143221.202160ae@hyperion.delvare>
	<49981F1B.8040302@f-seidel.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009 14:56:43 +0100, Frank Seidel wrote:
> Hi,
> 
> Jean Delvare wrote:
> > On Sun, 15 Feb 2009 13:28:23 +0100, Frank Seidel wrote:
> >>  M:	linux-kernel@vger.kernel.org
> > 
> > I had never noticed this. Either hdaps is considered a hardware
> > monitoring driver and the list should be lm-sensors@lm-sensors.org, or
> > it's not and the driver should be moved to a different directory
> > (drivers/misc, drivers/mfd, whatever.)
> 
> Ok, so i'll change this to lm-sensors and subscribe me there.

OK. Oh, and this really should be an L: entry, not M:. I can change
that myself.

> 
> >> -W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
> >> +W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/
> > 
> > There doesn't appear to be anything hdaps-specific at this address, so
> > it's probably not worth mentioning.
> 
> Not yet, but i plan to in the next hours or days. Sadfully i'm just
> currently struggling with access to my old kernel.org account.

OK. Out of curiosity, what do you plan to put there?

-- 
Jean Delvare
