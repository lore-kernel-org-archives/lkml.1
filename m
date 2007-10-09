Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXJIJx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXJIJx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 05:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXJIJxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 05:53:52 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53638 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752292AbXJIJxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 05:53:51 -0400
Date: Tue, 9 Oct 2007 11:54:18 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071009095418.GR16424@stusta.de>
References: <20071008200255.GA16497@uranus.ravnborg.org> <20071008211255.GP16424@stusta.de> <20071009060333.GB22087@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071009060333.GB22087@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 08:03:33AM +0200, Sam Ravnborg wrote:
> On Mon, Oct 08, 2007 at 11:12:56PM +0200, Adrian Bunk wrote:
>...
> > BTW: I'm currently trying without success to understand why the
> >      drivers/infiniband/{hw/amso1100,ulp/srp}/Kbuild files are not
> >      named "Makefile".
> Giacomo explained this already..
> But I have never done a global renaming - the
> pain/benefit ratio seems too low.

Either keep all as "Makefile" or rename all.

But being inconsequent creates maximum confusion.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

