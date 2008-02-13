Return-Path: <linux-kernel-owner+w=401wt.eu-S935601AbYBMWId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935601AbYBMWId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935237AbYBMWFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:05:54 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57434 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934466AbYBMWFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:05:52 -0500
Date: Thu, 14 Feb 2008 00:05:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 aoedev_isbusy()
Message-ID: <20080213220537.GA24319@cs181133002.pp.htv.fi>
References: <20080213213002.GT3383@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0802132303150.29154@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802132303150.29154@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:03:35PM +0100, Jan Engelhardt wrote:
> 
> On Feb 13 2008 23:30, Adrian Bunk wrote:
> >
> >This patch #if 0's the no longer used aoedev_isbusy().
> 
> Why not just remove it? (It can be resurrected from earlier
> revisions should it be needed again.)

I've switched to doing #if 0 instead since this addresses the
"It might be needed in the future." answer I otherwise sometimes
got.

But if a maintainer wants to have such a function deleted instead that's 
fine with me.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

