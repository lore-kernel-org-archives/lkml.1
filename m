Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYFOKlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYFOKlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 06:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbYFOKkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 06:40:53 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58093 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbYFOKkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 06:40:52 -0400
Date: Sun, 15 Jun 2008 13:39:35 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Romano Giannetti <romano@dea.icai.upcomillas.es>
Cc: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
	and VESA framebuffer
Message-ID: <20080615103934.GB21168@cs181133002.pp.htv.fi>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <Jn7irxIunJK.A._5D.LJDVIB@albercik> <200806142359.36613.elendil@planet.nl> <1213525379.15067.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1213525379.15067.3.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 12:22:59PM +0200, Romano Giannetti wrote:
> 
> On Sat, 2008-06-14 at 23:59 +0200, Frans Pop wrote:
> > \>
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10843
> > > Subject	: Display artifacts on XOrg logout with PAT kernel and VESA
> > > 		  framebuffer
> > > Submitter	: Frans Pop <elendil@planet.nl> 
> > > Date		: 2008-05-31 14:04 (15 days old)
> > > References	: http://lkml.org/lkml/2008/6/7/206
> > 
> > Yes. See also: http://lkml.org/lkml/2008/6/13/159
> > -
> 
> It happens to me too. Do you see
> http://bugzilla.kernel.org/show_bug.cgi?id=10892 ?

Does disabling CONFIG_X86_PAT also fix it for you?

> Romano

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

