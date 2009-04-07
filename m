Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbZDGLZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbZDGLZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbZDGLZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:25:22 -0400
Received: from smtp191.iad.emailsrvr.com ([207.97.245.191]:51615 "EHLO
	smtp191.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZDGLZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:25:20 -0400
From: "Christopher J. Harrer" <charrer@alacritech.com>
To: "'maximilian attems'" <max@stro.at>
Cc: "'Mithlesh Thukral'" <mithlesh@linsyssoft.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <debian-kernel@lists.debian.org>,
       "'Greg Kroah-Hartman'" <gregkh@suse.de>
References: <200904070037.48064.mithlesh@linsyssoft.com> <20090406135557.EA7091B4039@relay31.relay.iad.mlsrvr.com> <20090406142540.GP3901@baikonur.stro.at> <20090407110115.GF4442@stro.at>
Subject: RE: Staging: sxg: slicoss: Specify the license for Sahara SXG andSlicoss drivers
Date: Tue, 7 Apr 2009 07:25:26 -0400
Message-ID: <ADD12BC063E7494F974D95C27F4B308B@workathome>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20090407110115.GF4442@stro.at>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Thread-Index: Acm3cDpaCmTXAxegScmony5oSTLkhgAAuDdQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: maximilian attems [mailto:max@stro.at] 
Sent: Tuesday, April 07, 2009 7:01 AM
To: Christopher J. Harrer
Cc: 'Mithlesh Thukral'; 'Linux Kernel Mailing List';
debian-kernel@lists.debian.org; Greg Kroah-Hartman
Subject: Re: Staging: sxg: slicoss: Specify the license for Sahara SXG
andSlicoss drivers

On Mon, 06 Apr 2009, 'maximilian attems' wrote:

> On Mon, Apr 06, 2009 at 09:56:07AM -0400, Christopher J. Harrer wrote:
> > -----Original Message-----
> > From: Mithlesh Thukral [mailto:mithlesh@linsyssoft.com]
> > Sent: Monday, April 06, 2009 3:08 PM
> > To: maximilian attems
> > Cc: Linux Kernel Mailing List; debian-kernel@lists.debian.org; 
> > Christopher Harrer
> > Subject: Re: Staging: sxg: slicoss: Specify the license for Sahara 
> > SXG and Slicoss drivers
> > 
> > CCing a person who can better comment.
> > 
> > Cheers,
> > Mithlesh Thukral
> > 
> > On Monday 06 April 2009 18:42:43 maximilian attems wrote:
> > > On Sun, 05 Apr 2009, Linux Kernel Mailing List wrote:
> > > > Gitweb:    
> > > > http://git.kernel.org/linus/ba0e1ebb7ea0616eebc29d2077355bacea62a9d8
> > > > Commit:     ba0e1ebb7ea0616eebc29d2077355bacea62a9d8
> > > > Parent:     19be358212af35bd64d449da82279874099a1a85
> > > > Author:     Mithlesh Thukral <mithlesh@linsyssoft.com>
> > > > AuthorDate: Wed Mar 25 15:52:54 2009 +0530
> > > > Committer:  Greg Kroah-Hartman <gregkh@suse.de>
> > > > CommitDate: Fri Apr 3 14:54:38 2009 -0700
> > > >
> > > >     Staging: sxg: slicoss: Specify the license for Sahara SXG 
> > > > and Slicoss drivers
> > > >
> > > >     Specify a license for the Alacritech Sahara (10Gbe) and 
> > > > SLICOSS
> > > > (1GBE) firmware files.
> > > >
> > > >     Signed-off-by: Christopher Harrer <charrer@alacritech.com>
> > > >     Signed-off-by: Mithlesh Thukral <mithlesh@linsyssoft.com>
> > > >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > > ---
> > > >  firmware/WHENCE |   33 ++++++++++++++++++++++++++++++---
> > > >  1 files changed, 30 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/firmware/WHENCE b/firmware/WHENCE index 
> > > > df79422..d6c227d 100644
> > > > --- a/firmware/WHENCE
> > > > +++ b/firmware/WHENCE
> > > > @@ -372,7 +372,21 @@ File: slicoss/oasisdbgdownload.sys.ihex
> > > >  File: slicoss/oasisdownload.sys.ihex
> > > >  File: slicoss/oasisrcvucode.sys.ihex
> > > >
> > > > -Licence: Unknown
> > > > +Licence:
> > > > +		Copyright (C) 1999-2009 Alacritech, Inc.
> > > > +
> > > > +	as an unpublished work. This notice does not imply
unrestricted or
> > > > +	public access to the source code from which this firmware
image is
> > > > +	derived.  Except as noted below this firmware image may not
be
> > > > +	reproduced, used, sold or transferred to any third party
without
> > > > +	Alacritech's prior written consent.  All Rights Reserved.
> > > > +
> > > > +	Permission is hereby granted for the distribution of this
firmware
> > > > +	image as part of a Linux or other Open Source operating
system
> > kernel
> > > > +	in text or binary form as required.
> > > > +
> > > > +	This firmware may not be modified and may only be used with
> > > > +	Alacritech hardware.
> > >
> > > have you read what you say?
> > >
> > > the last paragraph disables the distribution right, due beeing 
> > > only allowed to be touched on alacritech hardware.
> > >
> > > i'm certainly not buying anything from alacritech, but would want 
> > > to disbribute your fimware in Debian in the nonfree firmware-linux 
> > > package for the benefit of your customers.
> > > -> http://packages.debian.org/sid/firmware-linux
> > >
> > > >  Found in hex form in kernel source.
> > > >
> > > > @@ -383,10 +397,23 @@ Driver: SXG - Alacritech IS-NIC products
> > > >  File: sxg/saharadownloadB.sys.ihex
> > > >  File: sxg/saharadbgdownloadB.sys.ihex
> > > >
> > > > -Licence: Unknown
> > > > +Licence:
> > > > +		Copyright (C) 1999-2009 Alacritech, Inc.
> > > > +
> > > > +	as an unpublished work. This notice does not imply
unrestricted or
> > > > +	public access to the source code from which this firmware
image is
> > > > +	derived.  Except as noted below this firmware image may not
be
> > > > +	reproduced, used, sold or transferred to any third party
without
> > > > +	Alacritech's prior written consent.  All Rights Reserved.
> > > > +
> > > > +	Permission is hereby granted for the distribution of this
firmware
> > > > +	image as part of a Linux or other Open Source operating
system
> > kernel
> > > > +	in text or binary form as required.
> > > > +
> > > > +	This firmware may not be modified and may only be used with
> > > > +	Alacritech hardware.
> > >
> > > same trouble,
> > > nuke the "and may only be used with Alacritech hardware."
> > Hello All,
> > 
> > I apologize in advance for the trouble this is causing.  We used an 
> > existing license in the WHENCE file as a template for our text.  The 
> > intention of our wording is not to limit the actual distribution of 
> > the firmware file; but to control the platform(s) the firmware file 
> > may be executed on (as opposed to stored).
> > 
> > Would changing to the wording to "This firmware may not be modified 
> > and may only be loaded to and executed on Alacritech hardware" be more
clear?
> > 
> > Other suggestions, short of removing the line altogether?
> > 
> > Thanks,
> > 
> > Chris Harrer
> > 
> 
> removing the line altogether seems the easiest solution for your users.
> 
> if they've gone through the trouble to copy the hardware and modify 
> the firmware to work w/ that.. are they really going to care about 
> violating the license?
 
once you already change the firmware you are indeed already violating the
license, so the proposed change for beeing able to distribute your firmware
is below.

please acknowledge belows change, so that greg can merge it.

thanks.


>From 138cbd51ee3c6f5d60be6fe92c4874c2db55fd69 Mon Sep 17 00:00:00 2001
From: maximilian attems <max@stro.at>
Date: Tue, 7 Apr 2009 12:52:34 +0200
Subject: [PATCH] Alacritech: reword firmware license to be distributable

by requesting the firmware to only be "used" on Alacritech products the
granted distribution right one paragraph above is negated.

Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: christopher harrer <charrer@alacritech.com>
---
 firmware/WHENCE |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/firmware/WHENCE b/firmware/WHENCE index c006af8..ba43c58 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -411,8 +411,7 @@ Licence:
 	image as part of a Linux or other Open Source operating system
kernel
 	in text or binary form as required.
 
-	This firmware may not be modified and may only be used with
-	Alacritech hardware.
+	This firmware may not be modified.
 
 Found in hex form in kernel source.
 
@@ -436,8 +435,7 @@ Licence:
 	image as part of a Linux or other Open Source operating system
kernel
 	in text or binary form as required.
 
-	This firmware may not be modified and may only be used with
-	Alacritech hardware.
+	This firmware may not be modified.
 
 Found in hex form in kernel source.
 
--
1.6.2.1

Hi Maximilian,

Thanks for taking care of this, your change is acceptable and covers our
concerns.

I added my "Signed-off-by", if it's not needed you can remove it.

Cheers,

Chris

