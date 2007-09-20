Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbXITQ25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbXITQ25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXITQ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:28:50 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:56570 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbXITQ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:28:49 -0400
Date: Thu, 20 Sep 2007 18:30:12 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.23-rc6-mm1: atomic counter underflow
Message-ID: <20070920183012.726bf289@poseidon.drzeus.cx>
In-Reply-To: <20070920153518.15e72a24@gondolin.boeblingen.de.ibm.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<200709182345.13435.m.kozlowski@tuxland.pl>
	<20070919102716.09004317@gondolin.boeblingen.de.ibm.com>
	<200709191843.54902.m.kozlowski@tuxland.pl>
	<20070919200205.057e3fbc@gondolin.boeblingen.de.ibm.com>
	<20070920153518.15e72a24@gondolin.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 15:35:18 +0200
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> On Wed, 19 Sep 2007 20:02:05 +0200,
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
> > -ECONFUSED. Perhaps DEBUG_DRIVER may help some more. Or /me getting
> > some sleep.
> 
> Sleeping helped (improved reading abilities).
> 
> From: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> mmc: Avoid double sdio_unregister_bus() on module unload.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 

oooops. :)

This has been pushed to kernel.org. Andrew, update at will.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
