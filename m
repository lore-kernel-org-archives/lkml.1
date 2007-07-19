Return-Path: <linux-kernel-owner+w=401wt.eu-S935652AbXGSHPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935652AbXGSHPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXGSHPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:15:41 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:39841 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758734AbXGSHPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:15:40 -0400
Date: Thu, 19 Jul 2007 09:15:38 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Paul Mackerras <paulus@samba.org>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
In-Reply-To: <20070719053302.GO11657@kernel.dk>
Message-ID: <Pine.LNX.4.62.0707190914320.12868@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.392129000@pademelon.sonytel.be> <20070718163637.3f0e0164.akpm@linux-foundation.org>
 <20070719053302.GO11657@kernel.dk>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1567109295-1184829289=:12868"
Content-ID: <Pine.LNX.4.62.0707190914570.12868@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1567109295-1184829289=:12868
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0707190914571.12868@pademelon.sonytel.be>

On Thu, 19 Jul 2007, Jens Axboe wrote:
> On Wed, Jul 18 2007, Andrew Morton wrote:
> > On Mon, 16 Jul 2007 18:15:40 +0200
> > Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > 
> > > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > > 
> > > Add a Disk Storage Driver for the PS3:
> > 
> > Your patchset significantly hits powerpc, scsi and block.  So who gets to
> > merge this?  Jens?  James?  Paul?
> > 
> > Me, I guess ;)
> 
> I think Paul was going to take it, or at least Geert hinted as such.

Yep, but as I heard Paul is on holidays, I was just going to send it to Andrew
anyway.

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1567109295-1184829289=:12868--
