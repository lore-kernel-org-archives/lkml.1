Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbXEIJ4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbXEIJ4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbXEIJxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:53:45 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:18740 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbXEIJxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SiUW5k2o4xwVr/L4He1VUlSp8t76AwHAq4y6SWcGDCLQtg9zyYeUhRkdT0wk/JrmHCOHsemEycjXhuytP3AwO3zbMmlGG4Lmt73C3V4YcAjtq6pDer5kgZTdZbJhyzmPVynR7YkX8rt7Tv4SgGyV2mUn4zp/EnQZuUAELpp/wVM=
Message-ID: <5486cca80705090253h7860267mfb5a3a52aeba36f1@mail.gmail.com>
Date: Wed, 9 May 2007 11:53:42 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Paul Fulghum" <paulkf@microgate.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <5486cca80705060006y38da02e1yddb0059a9b717b3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178384675.3379.26.camel@x2>
	 <5486cca80705051108p55b2cddfydce54aa15dd317f4@mail.gmail.com>
	 <200705052035.58782.oliver@neukum.org>
	 <5486cca80705060006y38da02e1yddb0059a9b717b3a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/6, Antonino Ingargiola <tritemio@gmail.com>:
> 2007/5/5, Oliver Neukum <oliver@neukum.org>:
> > Am Samstag, 5. Mai 2007 20:08 schrieb Antonino Ingargiola:
> > > Now I don't want to abuse your kindness, but I (personally) would be
> > > *really* interested in a similar fix for the FTDI usb-serial driver,
> > > because many measurements I do use an FTDI device.
> >
> > Does this work?
> >
>
> Thanks for the patch! Alas, I will have access to an FTDI device only
> on Tuesday, then I'll test it and report results.

Sorry. I've not been able to try this ftdi patch yet. My work pc has
ubuntu dapper with 2.6.15 kernel. I've compiled 2.6.21 there but the
leap is too much and there are probably udev incompatibilities so the
/dev entry is not created for any USB device.

I need to install a newer distro to work with mainline.

This mail is just to point out that the patch is not forgotten, just
need more time to try it.


Regards,

  ~ Antonio
