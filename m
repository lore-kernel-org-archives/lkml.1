Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbXFFKjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbXFFKjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbXFFKjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:39:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:38567 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758026AbXFFKjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:39:17 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX1/z6qoZWVrzetqFVMS8vHg1A5p/XQUKKgykYkIFbG
	vNW5tZVbYklQyX
Message-ID: <46668ED5.5000807@gmx.de>
Date: Wed, 06 Jun 2007 12:39:17 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, "Lars K.W. Gohlke" <lkwg82@gmx.de>
Subject: Re: serio interface
References: <46667A3B.8070708@gmx.de> <20070606091503.GI2649@lug-owl.de> <46667FB9.70206@gmx.de> <20070606095159.GK2649@lug-owl.de>
In-Reply-To: <20070606095159.GK2649@lug-owl.de>
Content-Type: multipart/mixed;
 boundary="------------000202010806040001010403"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------000202010806040001010403
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jan-Benedict Glaw schrieb:
> On Wed, 2007-06-06 11:34:49 +0200, Lars K.W. Gohlke <lkwg82@gmx.de> wrote:
>> Jan-Benedict Glaw schrieb:
>>> On Wed, 2007-06-06 11:11:23 +0200, Lars K.W. Gohlke <lkwg82@gmx.de> wrote:
>>>> wouldsomebody explain me the serio interface or give me a code link for
>>>> very simple example.
>>> What do you want to do with it?  Do you want on the serial port side,
>>> or on the mouse/keyboard/gadget side?  See for example the various
>>> serial keyboards and mice drivers.
>> I want on the kernelside process data from first uart-hardware interface
>> aka ttyS0.
>>
>> I don't understand the structure of e.g. input/mouse/sermouse.c
>>
>> where is said, which hardware is used for reading data from?
>
> I'm not entirely sure, but I guess that most of the time, you assign a
> serial port with the help of `inputattach' to a given device driver,
> which expects to find its hardware on that port.
>
> OTOH, why do you want to do the serial stuff in kernel land? Isn't it
> a *lot* easier to do it in userspace? What's your specific device you
> want to work on?
>
> MfG, JBG
>

if you want to write a driver, there must be a possibility to get the
data, like others do. (kernel-space)

I want to know where I can get and how to do.

At least I want to be able to copy the data from device to another
(maybe own).

It is to get familiar with that.

thx
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGZo7XAAomYJ1taN8RAgdAAJ0f1PilbuuwK8USjfLIDDGR1bPB3QCfdxmn
16d7ERDrASzpOYomyjs80rM=
=ZnRu
-----END PGP SIGNATURE-----

--------------000202010806040001010403
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lkwg82.vcf"

YmVnaW46dmNhcmQNCmZuOkxhcnMgSy5XLiBHb2hsa2UNCm46R29obGtlO0xhcnMgSy5XLg0K
ZW1haWw7aW50ZXJuZXQ6bGt3ZzgyQGdteC5kZQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZl
cnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------000202010806040001010403--

