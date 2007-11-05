Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbXKEHeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbXKEHeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 02:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXKEHdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 02:33:51 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:49958 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbXKEHdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 02:33:50 -0500
Date: Mon, 5 Nov 2007 08:31:58 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Roland Dreier <rdreier@cisco.com>
Cc: Romano Giannetti <romanol@upcomillas.es>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071105083158.083a70f9@poseidon.drzeus.cx>
In-Reply-To: <ada8x5ec7oh.fsf@cisco.com>
References: <1193918202.8439.7.camel@rukbat>
	<20071102182833.2c055446@poseidon.drzeus.cx>
	<1194168583.10245.15.camel@rukbat>
	<ada8x5ec7oh.fsf@cisco.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2007 08:11:10 -0800
Roland Dreier <rdreier@cisco.com> wrote:

> 
> When I put the same card back in the camera and used the camera's dock
> to access the data via USB mass storage, everything worked fine.  So
> it does seem to be at least somewhat MMC-related.
> 

Since there was no error from the mmc level there, I wouldn't be so sure. Could you try a complete fsck of the card to check that the camera is constructing a proper FAT?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
