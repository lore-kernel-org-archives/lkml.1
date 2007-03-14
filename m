Return-Path: <linux-kernel-owner+w=401wt.eu-S1030826AbXCNJoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030826AbXCNJoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030837AbXCNJoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:44:44 -0400
Received: from smtp23.orange.fr ([80.12.242.50]:1857 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030835AbXCNJon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:44:43 -0400
X-ME-UUID: 20070314094441865.D339E1C0009E@mwinf2348.orange.fr
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Xavier Bestel <xavier.bestel@free.fr>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Valdis.Kletnieks@vt.edu, Kasper Sandberg <lkml@metanurb.dk>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <45F76B0F.1050702@googlemail.com>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703122022.43021.kernel@kolivas.org>
	 <1173692319.5835.611.camel@frg-rhel40-em64t-03>
	 <200703122134.13554.kernel@kolivas.org>
	 <1173717518.26350.6.camel@localhost>
	 <200703140225.l2E2PJ2k007003@turing-police.cc.vt.edu>
	 <45F76B0F.1050702@googlemail.com>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 10:44:31 +0100
Message-Id: <1173865471.9840.52.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 04:25 +0100, Gabriel C wrote:
> Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 12 Mar 2007 17:38:38 BST, Kasper Sandberg said:
> >   
> >> with latest xorg, xlib will be using xcb internally,
> >>     
> >
> > Out of curiosity, when is this "latest" Xorg going to escape to distros,
> >   
> 
> Already is .. Xorg 7.2+ libx11 build with xcb enabled..

I think the true improvement will come when toolkits (GTK+ & Qt) are
ported to xcb.

	Xav


