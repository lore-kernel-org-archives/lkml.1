Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbXIYE0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbXIYE0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXIYE0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:26:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35091 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567AbXIYE0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:26:05 -0400
Date: Tue, 25 Sep 2007 06:26:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 1/3] Virtualization config cleanup: Select
	CONFIG_PARAVIRT when required
Message-ID: <20070925042623.GM6800@stusta.de>
References: <1190692688.27805.276.camel@localhost.localdomain> <20070925040537.GL6800@stusta.de> <1190694003.27805.291.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1190694003.27805.291.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 02:20:03PM +1000, Rusty Russell wrote:
> On Tue, 2007-09-25 at 06:05 +0200, Adrian Bunk wrote:
> > depends on !(X86_VISWS || X86_VOYAGER)
> 
> Hmm, if A selects B and B depends on C, does A not depend on C?

No.

> If not, I'll patch this...
> 
> Thanks,
> Rusty.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

