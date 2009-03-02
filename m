Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZCBOeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZCBOeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZCBOdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:33:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:41561 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbZCBOdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:33:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S/sjpELKUDBTzz23b+3a9BIrA3yfV0Ev84KjmZ9ippaxWsU7+7Bu91x9SKNTMjndfQ
         XhA80SLa7azqoQ+jDQ2sxSxtdz1Y/zE17pfMbTyzz+hZ0E5yzh/kofJSuDrsDeD68Qeo
         JuCkf7qioax/CBWr3v7Lwx6ocy6yKbJrQf4R0=
MIME-Version: 1.0
In-Reply-To: <200903021513.01356.oliver@neukum.org>
References: <20831c740903020539h68f62f2fj1575408d89050d25@mail.gmail.com>
	 <200903021513.01356.oliver@neukum.org>
Date: Mon, 2 Mar 2009 16:33:42 +0200
Message-ID: <20831c740903020633r40cc3a3fh5eb74eacd9026d3e@mail.gmail.com>
Subject: Re: usb hotplug and hooking
From: Oguz Yarimtepe <comp.ogz@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will look at the udev scripting. I don't need a GUI, yet. I will
just communicate with the usb device, check its files and if an
authorized software is found (will use asymmetric cryptography) will
load it.  I can write the software that will do the mentioned things.
I just don't know the hooking part. But udev is a good start. Thanks.

2009/3/2 Oliver Neukum <oliver@neukum.org>
>
> Am Montag 02 März 2009 14:39:41 schrieb Oguz Yarimtepe:
> > Hi,
> >
> > I want to run an application when an external usb flash disk is plugged to
> > my box machine that has STLinux installed in it. My aim is to check some
> > issues on usb disk, whether it has an official software or not. I am not
> > sure how will i hook my own application that will check usb device
> > when it is plugged. I don't want the application run at the
> > background, but run only when a plug is occured.
>
> Have you looked at writing a udev script? Do you need a GUI?
>
>        Regards
>                Oliver
>



--
Oðuz Yarýmtepe
www.loopbacking.info
