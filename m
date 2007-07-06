Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbXGFNBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbXGFNBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 09:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbXGFNBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 09:01:10 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:36635 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165AbXGFNBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 09:01:09 -0400
Date: Fri, 6 Jul 2007 15:01:04 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Milan Plzik <milan.plzik@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SD card readable only up to certain boundary (samcop sdi
 controller)
Message-ID: <20070706150104.51a3067d@poseidon.drzeus.cx>
In-Reply-To: <1183670244.9213.81.camel@localhost>
References: <1183670244.9213.81.camel@localhost>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.11.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jul 2007 23:17:24 +0200
Milan Plzik <milan.plzik@gmail.com> wrote:

> 
>   The SD card works correctly with other devices, like PCMCIA card
> readers. Also samcop sdi was able to fully read 512MB card. I'm not
> really sure what could cause behavior like this and I'm open to any
> suggestion.
> 

No idea, but as it works well in other devices and I've not seen
anything reports resembling this, I'd guess the driver/hw is buggy. But
as I haven't seen said driver I cannot guess what the problem might be.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
