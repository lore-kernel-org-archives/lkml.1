Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYAAXMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYAAXMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbYAAXL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:11:56 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50590 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845AbYAAXLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:11:55 -0500
Date: Wed, 2 Jan 2008 01:11:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove broken MTD drivers
Message-ID: <20080101231140.GF27566@does.not.exist>
References: <20080101134839.GN2360@does.not.exist> <1199205057.6315.67.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1199205057.6315.67.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 04:30:57PM +0000, David Woodhouse wrote:
> On Tue, 2008-01-01 at 15:48 +0200, Adrian Bunk wrote:
> > This patch removes two MTD drivers that have been marked as
> > BROKEN 19 months ago due to requiring nonexisting header files.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Any particular reason you didn't Cc the authors identified in the
> drivers you're removing?

The header of ppchameleonevb.c claims it comes from info@wawnet.biz 
which bounces and the header of toto.c contains as only address Thomas'
address (I took the wrong one from the commit, but bounced the email
to him).

> dwmw2

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

