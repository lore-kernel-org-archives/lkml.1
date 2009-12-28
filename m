Return-Path: <linux-kernel-owner+w=401wt.eu-S1751447AbZL1BB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbZL1BB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 20:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZL1BB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 20:01:27 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:43423 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZL1BB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 20:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=LqYlkFQSFGXWXX1MyX7piSirm2Fe1gWutAWl75NEB/oHYzFfsWqLe3QiN5HgkdQHhZ
         FfGgqY2w4fSxEvc1tzYC7i99uYxIsuO+WwaLaChmyBDatarHdicXbxzYx4M+EsAkQ+fD
         NlVc/xVorMQB/v8o8WjRzB/FL2RlWq98W2EBY=
Message-ID: <4B380361.6010302@gmail.com>
Date: Sun, 27 Dec 2009 20:01:21 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Alacrityvm-devel] [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org>	 <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com>	 <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu>	 <20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com>	 <4B325E33.8060407@gmail.com> <4B327B90.2050403@redhat.com> <b233dd490912231321p5e09946at5ea63cb0d0fa1489@mail.gmail.com> <4B3725CE.8040004@redhat.com> <4B375EAD.8050204@gmail.com> <4B3760D2.3080500@redhat.com> <4B376391.40706@gmail.com> <4B376604.4060808@redhat.com>
In-Reply-To: <4B376604.4060808@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig661F7BF24FA59BD1430E0B75"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig661F7BF24FA59BD1430E0B75
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/27/09 8:49 AM, Avi Kivity wrote:
> On 12/27/2009 03:39 PM, Gregory Haskins wrote:
>> No, where we are is at the point where we demonstrate that your origin=
al
>> statement that I did nothing to improve virtio was wrong.
>>
>>   =20
>=20
> I stand by it.  virtio + your patch does nothing without a ton more wor=
k
> (more or less equivalent to vhost-net).
>=20

Perhaps, but my work predates vhost-net by months and that has nothing
to do with what we are talking about anyway.  Since you snipped your
original comment that started the thread, here it is again:

On 12/23/09 5:22 AM, Avi Kivity wrote:
> >
> > There was no attempt by Gregory to improve virtio-net.

It's not a gray area, nor open to interpretation.  That statement was,
is, and will always be demonstrably false, so I'm sorry but you are
still wrong.

-Greg


--------------enig661F7BF24FA59BD1430E0B75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAks4A2EACgkQP5K2CMvXmqGQsACff/sLWmzTADpXqj7204yUtCGL
BLgAnR8msBEDPSuaF1m5ADVYO/RT9WiB
=2xta
-----END PGP SIGNATURE-----

--------------enig661F7BF24FA59BD1430E0B75--
