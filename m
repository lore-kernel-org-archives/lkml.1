Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbZD1WHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbZD1WHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZD1WGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:06:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZD1WGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:06:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [Bug #13177] 2.6.30-rc2-git7 build problem
Date: Wed, 29 Apr 2009 00:06:51 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-usb@vger.kernel.org
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera> <Fg2zLW93smL.A.9VC.wc48JB@chimera> <906747.62115.qm@web32604.mail.mud.yahoo.com>
In-Reply-To: <906747.62115.qm@web32604.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904290006.51707.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Martin Knoblauch wrote:
> ----- Original Message ----
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > Cc: Kernel Testers List <kernel-testers@vger.kernel.org>; Martin Knoblauch <spamtrap@knobisoft.de>
> > Sent: Saturday, April 25, 2009 9:31:51 PM
> > Subject: [Bug #13177] 2.6.30-rc2-git7 build problem
> > 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13177
> > Subject        : 2.6.30-rc2-git7 build problem
> > Submitter    : Martin Knoblauch 
> > Date        : 2009-04-21 13:39 (5 days old)
> > References    : http://marc.info/?l=linux-kernel&m=124032163602132&w=4
> 
>  still happens with 2.6.30-rc3-git7 when USB_SERIAL_KLSI=m.
> 
> BUILD   arch/x86/boot/bzImage
> Root device is (104, 3)
> Setup is 12664 bytes (padded to 12800 bytes).
> System is 2651 kB
> CRC 4864576
> Kernel: arch/x86/boot/bzImage is ready  (#2)
>   Building modules, stage 2.
>   MODPOST 470 modules
> ERROR: ".L192" [drivers/usb/serial/kl5kusb105.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
>  Config attached.

Thanks for the update.

Rafael
