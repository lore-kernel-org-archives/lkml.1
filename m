Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018Ab0AFRsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0AFRsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992Ab0AFRsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:48:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:40957 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab0AFRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:48:19 -0500
Date: Wed, 6 Jan 2010 17:48:18 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Miles Lane <miles.lane@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       linux-fbdev@vger.kernel.org
Subject: Re: 2.6.33-rc3 -- Intel 945GME (inteldrmfb) -- Two Tux images 
 displayed are side by side (should only show one).
In-Reply-To: <a44ae5cd1001060942p7672768yec3b1f5ea2426682@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001061747250.5372@casper.infradead.org>
References: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>  <alpine.LFD.2.00.1001061736080.5372@casper.infradead.org> <a44ae5cd1001060942p7672768yec3b1f5ea2426682@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1985284609-1967267537-1262800098=:5372"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1985284609-1967267537-1262800098=:5372
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


> On Wed, Jan 6, 2010 at 12:37 PM, James Simmons <jsimmons@infradead.org> wrote:
> >
> >> For a long time I have gotten two pictures of Tux showing up when I
> >> include the Tux display option in my custom kernel builds.  I don't
> >> know how many kernel revisions ago it was when I started noticing
> >> this.  It seems like it might have been early in the 2.6 series
> >> kernels.
> >>
> [...]
> >> # Frame buffer hardware drivers
> >> #
> >> CONFIG_FB_VESA=y
> >> CONFIG_FB_EFI=y
> >
> > Try disabling these two above options.
> 
> Well, that means that I don't get Tux at all.  The point is that only
> one copy should be displayed.

I thought you had KMS enabled?? That provides a fbdev emulation layer.

--1985284609-1967267537-1262800098=:5372--
