Return-Path: <linux-kernel-owner+w=401wt.eu-S965590AbXA3PNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590AbXA3PNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965593AbXA3PNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:13:34 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50185 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965590AbXA3PNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:13:33 -0500
Date: Tue, 30 Jan 2007 16:13:42 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC: -mm patch] CONFIG_INPUT_DEBUG improvements
Message-ID: <20070130151342.GH3754@stusta.de>
References: <20070127234928.64d8e437.akpm@osdl.org> <20070130011156.GD3754@stusta.de> <Pine.LNX.4.64.0701301603590.9448@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701301603590.9448@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 04:07:04PM +0100, Jiri Kosina wrote:
> On Tue, 30 Jan 2007, Adrian Bunk wrote:
> 
> > This patch contains the following CONFIG_INPUT_DEBUG improvements:
> > - remove Makefile code for the nonexisting CONFIG_INPUT_DEBUG
> > - simpler Makefile for hid-debug.o
> > - replace all HID debug #define's with CONFIG_INPUT_DEBUG
> 
> Adrian,
> 
> thanks for the patch. In seems broken to me though (as I have written 
> accidentaly in different mail, so resending for mailinglists to get it) - 
> the option that should replace the legacy DEBUG macro should be 
> CONFIG_HID_DEBUG, not CONFIG_INPUT_DEBUG - your patch gets it right only 
> on some places.
>...

Thanks for the correction, these were copy'n'paste errors in my patch.

> Jiri Kosina

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

