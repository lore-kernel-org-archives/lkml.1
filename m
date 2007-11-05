Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbXKEP1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbXKEP1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 10:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXKEP1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 10:27:45 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:58184 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbXKEP1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 10:27:44 -0500
Date: Mon, 5 Nov 2007 16:25:48 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071105162548.05b668ad@poseidon.drzeus.cx>
In-Reply-To: <1194270705.27789.6.camel@localhost>
References: <1193918202.8439.7.camel@rukbat>
	<20071102182833.2c055446@poseidon.drzeus.cx>
	<1194168583.10245.15.camel@rukbat>
	<ada8x5ec7oh.fsf@cisco.com>
	<1194259886.6927.9.camel@localhost>
	<20071105132218.495f244e@poseidon.drzeus.cx>
	<1194270705.27789.6.camel@localhost>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2007 14:51:45 +0100
Romano Giannetti <romanol@upcomillas.es> wrote:

> 
> On Mon, 2007-11-05 at 13:22 +0100, Pierre Ossman wrote:
> > On Mon, 05 Nov 2007 11:51:26 +0100
> > Romano Giannetti <romanol@upcomillas.es> wrote:
> 
> Ah, I forgot: I have a dump of the card (made with dd). If you'd happen
> to need it, simply tell me. dd gave no errors. 
> 

Please try to loop back mount that image and see if the problem remains.

> And to double check, I mounted a VFAT USB stick on the same PC, and
> there are no VFAT errors. So it seems an interaction VFAT-mmc...

Could you do a dump via both MMC and USB and compare the two?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
