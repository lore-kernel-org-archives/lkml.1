Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbYFULVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbYFULVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 07:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYFULVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 07:21:20 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60262 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYFULVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 07:21:20 -0400
Date: Sat, 21 Jun 2008 14:19:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: (Resend of 23/70 plus reply [PATCH 00/70] tty updates proposed
	for 2.6.27)
Message-ID: <20080621111936.GB27069@cs181133002.pp.htv.fi>
References: <20080620195406.1479.12620.stgit@localhost.localdomain> <20080621090910.GA12516@kroah.com> <20080621111709.7e8f7d44@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080621111709.7e8f7d44@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 11:17:09AM +0100, Alan Cox wrote:
>
> > Ah, thanks for resending these, as they are primarily USB changes, any
> > objection for me to take these through my USB tree?
>
> None at all. I've attached 23/70 which got eaten originally by a size
> limit.
>
> Alan
>
> usb_serial: API all change
>...

The USB_SERIAL_TI_FIRMWARE bits don't seem to belong here?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

