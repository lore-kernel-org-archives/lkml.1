Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbXIOQVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbXIOQVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 12:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXIOQVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 12:21:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36393 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXIOQVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 12:21:06 -0400
Date: Sat, 15 Sep 2007 18:21:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Paul Rolland <rol@as2917.net>, Andi Kleen <andi@firstfloor.org>,
       Vojtech Pavlik <vojtech@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: x86_64 usability bug: Kconfig prompt without help text (was Re: sata & scsi suggestion for make menuconfig)
Message-ID: <20070915162102.GA13264@one.firstfloor.org>
References: <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <20070915080448.37457dcf@tux.DEF.witbe.net> <46EB9703.70705@s5r6.in-berlin.de> <20070915130010.4272403c@tux.DEF.witbe.net> <46EBFF5C.8090605@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EBFF5C.8090605@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   - So, which criteria influence whether HPET_EMULATE_RTC should be
>     enabled on x86_64 or not?

If there is one it needs to be a runtime switch anyways.
> 
>   - In case that there is no compelling reason to disable it if its
>     dependencies are satisfied, shouldn't it rather be invisible and
>     automatic like on i386?

It should be automatic. Please send a patch.

-Andi
