Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZK2Wah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZK2Wah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 17:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZK2Wag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 17:30:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37471 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbZK2Wag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 17:30:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "werner" <w.landgraf@ru.ru>
Subject: Re: pci=off
Date: Sun, 29 Nov 2009 23:30:53 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <web-96228708@zbackend1.aha.ru>
In-Reply-To: <web-96228708@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911292330.53914.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 November 2009, werner wrote:
> "werner" <w.landgraf@ru.ru>
> In the last time, more and more laptops have problems to 
> boot with Linux.
> 
> The most frequent problem is that IDE drives are not 
> found, or cannot be accessed because reclaimed as ocupied. 
>   The only mean to access them and to get it booted, is 
> with pci=off.

I'm not sure it is not.

> However, with this, the system becomes 
> almost unuseable, lspci also shows nothing.      ITS 
> NECESSARY THAT SOMEONE MAKE A KERNEL PARAMETER  pci=noide 
> , so that all hardware is registered, with exception of 
> ide (and sata) drives   !!!!   This problem, for example, 
> also happens on IBM/Lenovo Thinkpad laptops.

No, it doesn't.

> A Toshibe Satelite laptop, I need go back to kernel 2.6.23 
> . With later kernels, at the beginning of the boot the 
> screen become black and nothing more happened.  The same 
> happens on that laptop with all newer Slackware kernels

Care to send .config from your kernel?

Rafael
