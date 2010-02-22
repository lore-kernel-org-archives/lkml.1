Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0BVMwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:52:12 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59441 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0BVMwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:52:10 -0500
Date: Mon, 22 Feb 2010 13:52:07 +0100
From: Andreas Mohr <andi@lisas.de>
To: Daniel Sangorrin <daniel.sangorrin@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Radek Liboska <liboska@uochb.cas.cz>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resubmit] USB: serial: ftdi: add CONTEC vendor and
	product id
Message-ID: <20100222125207.GA19299@rhlx01.hs-esslingen.de>
References: <6ea9ef0f1002200520w7ad62618hc680380142f5f0d@mail.gmail.com> <20100220171423.GA30123@rhlx01.hs-esslingen.de> <6ea9ef0f1002211803u6b39ab48ybb73c56e06a7fa03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ea9ef0f1002211803u6b39ab48ybb73c56e06a7fa03@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 22, 2010 at 11:03:11AM +0900, Daniel Sangorrin wrote:
> Hi
> 
> > Andreas Mohr:
> > This VID is not sorted (which also leads to a possibility of merge conflicts),
> > perhaps resubmit?
> 
> Sorry (^^), here is the new patch. Hope it is sorted now (although in
> ftdi_sio.c it didnt seem to be sorted)

Thanks!
Yes, it's sorted. And yes, it's not sorted ;) (I didn't get around to
sorting it there yet, it's on my ToDo list).

I will also add a comment to the end of ftdi_sio_ids.h (and .c) to avoid future
(non-)sorting confusion.

Andreas Mohr
