Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbZDRRxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbZDRRxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 13:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZDRRxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 13:53:31 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:24248 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZDRRxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 13:53:30 -0400
Message-ID: <49EA1392.5060008@poczta.fm>
Date: Sat, 18 Apr 2009 19:53:22 +0200
From: Lukasz Stelmach <stlman@poczta.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090403)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use multitouch touchpad events as buttons mousedev
References: <49B46ADA.5060809@poczta.fm> <20090416021126.GE2413@dtor-d630.eng.vmware.com>
In-Reply-To: <20090416021126.GE2413@dtor-d630.eng.vmware.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------020804090403020603020907"
X-EMID: 496aa138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020804090403020603020907
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dmitry Torokhov pisze:
> Hi Lukasz,
> 
> On Mon, Mar 09, 2009 at 02:03:22AM +0100, Lukasz Stelmach wrote:
>> Some touchpads can recognize multi-finger taps. They can be used as
>> additional buttons (left and middle).
>>
> 
> mousedev is a legacy interface and I don't think this change is needed
> since evdev + Synaptics X driver combination works much better with
> touchpads anyway.

That is true, however, I happen to use plain old virtual terminal with
gpm which uses mousedev. Having that multitouch buttons is, I assure you,
awesome.

- --
Było mi bardzo miło.               Czwarta pospolita klęska, [...]
>Łukasz<                 Już nie katolicka lecz złodziejska.  (c)PP
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknqE5EACgkQNdzY8sm9K9xsHwCeJhgMydNi4jw9RfNmu571aya+
lwMAoJJIflw/4kVnJ33G4Xte60MHUqGE
=/lR+
-----END PGP SIGNATURE-----


----------------------------------------------------------------------
Najlepsze dzwonki MP3 na telefon komorkowy!
Sprawdz >> http://link.interia.pl/f2128  

--------------020804090403020603020907
Content-Type: text/x-vcard; charset=utf-8;
 name="stlman.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="stlman.vcf"

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6PUM1PTgxdWthc3ogU3RlbG1hY2gN
Cm47cXVvdGVkLXByaW50YWJsZTpTdGVsbWFjaDs9QzU9ODF1a2Fzeg0KZW1haWw7aW50ZXJu
ZXQ6c3RsbWFuQHBvY3p0YS5mbQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZlcnNpb246Mi4x
DQplbmQ6dmNhcmQNCg0K
--------------020804090403020603020907--
