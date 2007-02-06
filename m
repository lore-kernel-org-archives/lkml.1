Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXBFXI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXBFXI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030533AbXBFXI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:08:28 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:55535 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519AbXBFXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:08:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nmtC5gu4AHrLND+aAYQIDHLZIEGamUDVrQFU39MWQXExMI6KK81AOqBz1g8UXp+bsGepdjxDj5VFJXk4AT1bDYRfSdqzsSgjqkFw/5pGcb17Fnb45UmSXcFLuOAnd6TKSnSiCyKm6/oT+P83nnLVTQOx+xPj5JMPy1bplwpIw1E=
Message-ID: <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
Date: Wed, 7 Feb 2007 00:08:26 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "James Simmons" <jsimmons@infradead.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "Luca Tettamanti" <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070128160831.fb51347f.akpm@osdl.org>
	 <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <20070128162907.370f5476.akpm@osdl.org>
	 <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
	 <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, James Simmons <jsimmons@infradead.org> wrote:
>
> If you can find post the manufacturer and model number we can place it on
> the backlist in fbmon. Also we should figure out what is wrong and fix it.

It's the UltraSharp UXGA display that used to come with Dell Inspiron
8200, 15" with a resolution of 1600x1200. I've been looking all around
for more info on it, but the only things I could find were posts that
remarked the problems Windows nVidia drivers have with some of these
(no image when running at 1600x1200), and other posts about banded
gradients with Windows drivers on Radeon video cards (but I get banded
gradients also win my nVidia card, on Linux, regardless of which
driver I use, binary, nv or nouveau).

As mentioned in another post in this thread, I can't get any info out
of the i2c busses, because even when I have them available (i.e. after
loading nvidiafb) I get XXXX all around (on all three of them).
Suggestions on how to get the information welcome.

-- 
Giuseppe "Oblomov" Bilotta
