Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYFOMYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYFOMYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 08:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbYFOMY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 08:24:29 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33711 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311AbYFOMY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 08:24:29 -0400
Date: Sun, 15 Jun 2008 15:23:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Romano Giannetti <romano@dea.icai.upcomillas.es>
Cc: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
	and VESA framebuffer
Message-ID: <20080615122311.GD21168@cs181133002.pp.htv.fi>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <Jn7irxIunJK.A._5D.LJDVIB@albercik> <200806142359.36613.elendil@planet.nl> <1213525379.15067.3.camel@localhost> <20080615103934.GB21168@cs181133002.pp.htv.fi> <1213529117.7003.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1213529117.7003.1.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 01:25:17PM +0200, Romano Giannetti wrote:
> 
> On Sun, 2008-06-15 at 13:39 +0300, Adrian Bunk wrote:
> > On Sun, Jun 15, 2008 at 12:22:59PM +0200, Romano Giannetti wrote:
> > > 
> 
> > > > Yes. See also: http://lkml.org/lkml/2008/6/13/159
> > > > -
> > > 
> > > It happens to me too. Do you see
> > > http://bugzilla.kernel.org/show_bug.cgi?id=10892 ?
> > 
> > Does disabling CONFIG_X86_PAT also fix it for you?
> 
> Dunno. Do I need to recompile or there is some boot option to disable
> it?

There's a nopat boot option.

> Rmano

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

