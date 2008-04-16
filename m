Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbYDPSBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbYDPSBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYDPSB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:01:26 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52987 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbYDPSB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:01:26 -0400
Date: Wed, 16 Apr 2008 21:01:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make mmc_wait_for_app_cmd() static
Message-ID: <20080416180120.GP1677@cs181133002.pp.htv.fi>
References: <20080413181555.GJ2182@cs181133002.pp.htv.fi> <20080416193637.46772cde@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080416193637.46772cde@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 07:36:37PM +0200, Pierre Ossman wrote:
> On Sun, 13 Apr 2008 21:15:55 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch makes the needlessly global mmc_wait_for_app_cmd() static.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> 
> Now this one I'm going to have to NAK. We've discussed this one before
>...

Sorry, I somehow lost the information that we iscussed this before.

> Rgds

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

