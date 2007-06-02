Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbXFBRzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbXFBRzy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760714AbXFBRzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:55:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51852 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760616AbXFBRzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:55:46 -0400
Date: Sat, 2 Jun 2007 19:55:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-ID: <20070602175548.GH5500@stusta.de>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net> <20070602141144.GC5500@stusta.de> <20070602104700.53b6b811.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070602104700.53b6b811.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 10:47:00AM -0700, Andrew Morton wrote:
> On Sat, 2 Jun 2007 16:11:45 +0200 Adrian Bunk <bunk@stusta.de> wrote:
>...
> > > -12) The canonical patch format
> > > +12) When to use Acked-by:
> > > +
> > > +The Signed-off-by: tag implies that the signer was involved in the development
> > > +of the patch, or that he/she was in the patch's delivery path.
> > 
> > The last part should be dropped: If "he/she was in the patch's delivery 
> > path", a Signed-off-by: tag is required.
> 
> I don't get you.  Isn't that already what the text says?
>...

/me blind

> +Acked-by: is often used by the maintainer of the affected code when that
> +maintainer neither contributed to nor forwarded the patch themselves.
> +
> +Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
> +has at least reviewed the patch and has indicated acceptance.  Hence patch
> +mergers will sometimes manually covert an acker's "yep, looks good to me" into
> +an Acked-by:.
> +
> +Acked-by: does not necessarily indicate acknowledgement of the entire patch. 
> +For example, if a patch affects multiple subsystems and has an Acked-by: from
> +one subsystem maintainer then this usually indicates acknowledgement of just
> +the part which affects that maintainer's code.  Judgement should be used here.
> +When in doubt people should refer to the original discussion in the mailing
> +list archives.
> +
> +
> +14) The canonical patch format
>...

Looks good to me.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

