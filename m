Return-Path: <linux-kernel-owner+w=401wt.eu-S937242AbXHJNfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937242AbXHJNfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763828AbXHJNfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:35:36 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:38732 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762348AbXHJNfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:35:34 -0400
Date: Fri, 10 Aug 2007 15:35:32 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: sdio: set host bus width
Message-ID: <20070810153532.2c27b47b@poseidon.drzeus.cx>
In-Reply-To: <46BC59B6.4060301@csr.com>
References: <46BC58E8.50300@csr.com>
	<46BC59B6.4060301@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 13:27:34 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> sdio: set host bus width
> 
> Need to set the bus width used by the host when enabling wide (4 bit)
> mode.
> 
> Signed-of-by: David Vrabel <david.vrabel@csr.com>

Now this is just embarrassing. Thanks for spotting it.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
