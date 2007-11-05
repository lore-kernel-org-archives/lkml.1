Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbXKEPe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbXKEPe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 10:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbXKEPeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 10:34:50 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:36939 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbXKEPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 10:34:49 -0500
Date: Mon, 5 Nov 2007 16:34:31 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRIS: Remove MTD_AMSTD and MTD_OBSOLETE_CHIPS
Message-ID: <20071105153431.GP7621@axis.com>
References: <20071105132102.GL7621@axis.com> <Pine.LNX.4.64.0711050928330.10444@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711050928330.10444@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 09:29:21AM -0500, Robert P. J. Day wrote:
> On Mon, 5 Nov 2007, Jesper Nilsson wrote:
> > --- a/arch/cris/arch-v10/defconfig
> > +++ b/arch/cris/arch-v10/defconfig
> > @@ -99,7 +99,7 @@ CONFIG_MTD=y
> >  CONFIG_MTD_CFI=y
> >  # CONFIG_MTD_CFI_INTELEXT is not set
> >  CONFIG_MTD_CFI_AMDSTD=y
> > -CONFIG_MTD_AMDSTD=y
> > +# CONFIG_MTD_AMDSTD is not set
> 
> why are you keeping this around?

Hmm... Good point. I'll resubmit the patch with the values removed entirely.

> rday

Thanks,

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
