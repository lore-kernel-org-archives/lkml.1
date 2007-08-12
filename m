Return-Path: <linux-kernel-owner+w=401wt.eu-S937533AbXHLP0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937533AbXHLP0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765427AbXHLPZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:25:55 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58262 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764595AbXHLPZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:25:53 -0400
Date: Sun, 12 Aug 2007 17:25:50 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@cam.org>
Subject: Re: [ANNOUNCE] SDIO soon in mainline
Message-ID: <20070812172550.46f389bf@poseidon.drzeus.cx>
In-Reply-To: <1186931551.6698.88.camel@violet>
References: <20070722185244.587d5bdc@poseidon.drzeus.cx>
	<1186931551.6698.88.camel@violet>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 17:12:31 +0200
Marcel Holtmann <marcel@holtmann.org> wrote:

> 
> and as of a few days ago we have a second driver that can handle
> Bluetooth Type-A and Type-B SDIO cards. It has been tested with a card
> from Socket which is actually manufactured by Toshiba.
> 

Nice. The way things are going right now, the sdio stack should be
merged first thing during the next merge window. So you should be able
to push this in as well.

(Not that you should stop testing and reviewing the code though ;))

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
