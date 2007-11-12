Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbXKLQO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbXKLQO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbXKLQOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:14:51 -0500
Received: from sitemail2.everyone.net ([216.200.145.36]:37701 "EHLO
	omta14.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752569AbXKLQOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:14:50 -0500
X-Eon-Dm: dm02
X-Eon-Sig: AQF97PZHOHu+Y5DqgQIAAAAB,5b999eae5e2f6d05c0296ce6079d1b1e
Message-ID: <47387BB5.4090908@smsglobal.net>
Date: Tue, 13 Nov 2007 00:13:41 +0800
From: "Rogelio M. Serrano Jr." <rogelio@smsglobal.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [poll] Is the megafreeze development model broken?
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de>
In-Reply-To: <20071112152057.GJ9771@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig651D40E8923B92B1E947E7F8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig651D40E8923B92B1E947E7F8
Content-Type: multipart/mixed;
 boundary="------------020702090309050407070405"

This is a multi-part message in MIME format.
--------------020702090309050407070405
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Adrian Bunk wrote:
> On Mon, Nov 12, 2007 at 01:51:25PM +0000, Tuomo Valkonen wrote:
>  =20
>> On 2007-11-12, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>    =20
>>> I think a megafreeze development model is sane.  Finding a collection=

>>> of software versions that are all known to work together is very
>>> interesting, and useful.  Making it so you can deliver something that=

>>> just works to end users is always interesting.
>>>      =20
>> The distros only do that for the most important and most popular
>> packages, most of which have become rather "generic" and faceless
>> behemots in the sense that they do not have definite authors and so
>> on, and for which it takes years to respond to bug reports in any case=

>> (if someone even bothers to enter the bug in registration-required
>> Suckzilla, Debian's reportbug becoming much more usable in this case,
>> even though it typically takes another year for the package maintainer=

>> to report things back upstream, if it ever even happens).
>>
>> Other more marginal software with a face, the distros just throw in
>> and expect the author to deal with users having problems with ancient
>> development snapshots and even bugs in stable versions that the distro=
s
>> simply refuse to fix. They should not distribute that kind of software=

>> at all. That is, distros should stick to providing stable base systems=
,=20
>> and fully supported (and renamed if not generic) customised versions o=
f
>> other software for their target audience. For the rest, there should
>> be better mechanisms for authors to distribute binary or otherwise
>> easily and reliably installable packages of their software.=20
>>    =20
>
> The problem is not what the distributions ship, the problem is simply=20
> that problems with distribution packaged software should be reported=20
> to the distribution, not upstream.
>
> And for becoming at least marginally on-topic again:
> Assuming your "stable base systems" contains the Linux kernel, how woul=
d
> you prevent users from reporting bugs in their ancient kernels [1] here=
?
>
>  =20
Isn't the kernel easier to sync with latest and greatest?

The core libc and supporting libraries is the core. and the toolchain
the core dev. Those can be updated twice or even once a year. The kernel
can be updated once a month if you like.

I stopped using debian myself and used DIY linux based toolchain and
libc. Thats the stable core that i have been using for 4 months. If
debian can reduce the footprint of the "stable core" and do monthly
releases of package bundles i will use it again.


--=20
Democracy is about two wolves and a sheep deciding what to eat for dinner=
=2E


--------------020702090309050407070405
Content-Type: text/x-vcard; charset=utf-8;
 name="rogelio.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rogelio.vcf"

YmVnaW46dmNhcmQNCmZuOlJvZ2VsaW8gTS4gU2VycmFubyBKcg0KbjpNLiBTZXJyYW5vIEpy
O1JvZ2VsaW8NCm9yZzpTTVNHIENvbW11bmljYXRpb25zIFBoaWxpcHBpbmVzO1RlY2huaWNh
bCBEZXBhcnRtZW50DQphZHI6Ozs7Ozs7UmVwdWJsaWMgb2YgdGhlIFBoaWxpcHBpbmVzDQpl
bWFpbDtpbnRlcm5ldDpyb2dlbGlvQHNtc2dsb2JhbC5uZXQNCnRpdGxlOlByb2dyYW1tZXIN
CnRlbDt3b3JrOis2MzI3NTM0MTQ1DQp0ZWw7aG9tZTorNjMyOTUyNzAyNg0KdGVsO2NlbGw6
KzYzOTIwOTIwMjI2Nw0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZlcnNpb246Mi4xDQplbmQ6
dmNhcmQNCg0K
--------------020702090309050407070405--

--------------enig651D40E8923B92B1E947E7F8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD4DBQFHOHu8yihxuQOYt8wRAj//AJUSJMwZbN6ycQRPMmhKf5dRf18MAKCOnZFt
FHdbT2ZRhHL0wthCxASlTw==
=v97y
-----END PGP SIGNATURE-----

--------------enig651D40E8923B92B1E947E7F8--
