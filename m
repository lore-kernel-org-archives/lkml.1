Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbXD2ONG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbXD2ONG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 10:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbXD2ONG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 10:13:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:55337 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756494AbXD2ONE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 10:13:04 -0400
X-Authenticated: #4011369
X-Provags-ID: V01U2FsdGVkX19JzDlecO5JdO7Dva3zv7eRbEho19uuva9fj6w+L9
	pfOhcPxtWICvTt
Subject: Re: Probable PCIE prob
From: Syren Baran <sbaran@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <p73hcqz1jmt.fsf@bingen.suse.de>
References: <1177790017.3649.23.camel@excalibur>
	 <p73hcqz1jmt.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 16:13:01 +0200
Message-Id: <1177855981.3578.9.camel@excalibur>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 29.04.2007, 13:54 +0200 schrieb Andi Kleen:
> Syren Baran <sbaran@gmx.de> writes:
> 
> > i got a problem with the combination of an Asrock AM2NF4G-SATA2
> > mainboard with a Radeon X1900 (chip 1002,724b) graphics
> > card. /i386/pci/mmconfig.c reports a buggy bios (e0000000 is not
> > E820-reserved).
> 
> This message is harmless and likely unrelated.
Maybe, but thats the only clue i can get from the kernel.
> 
>  System crashes only happen when viewing films (neither
> > xine nor mplayer run with root privileges) and independent of video
> > drivers (framebuffer, vesa and fglrx). Logs dont show any anomalies
> > before crashing. Anybody got a clue?
> 
> Sounds like some sort of hardware problem. Maybe the power supply
> is not up to the task?
Definatly not, already replaced that with a 550W power supply.
>  Or the board could be broken.
Most likely not. I recently actually installed Windows XP to check.
Granted, just watching one film may not have been long enough to trigger
this effect (the crashes usually take place after 1/2 an hour, though
times can vary largely).
>  Also always
> worth updating the BIOS.
Did that long before posting. Changing the PCIE frequency in the BIOS
didnt help either.
> 
> -Andi

Syren

