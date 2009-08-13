Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZHMMFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZHMMFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZHMMFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:05:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:24017 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZHMMFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=h17FF3mAhkzP/+dBBn9ycdNY+a5jVWa0LZ9tU4HlwccfmdEIPKxRL/qVS7ncoJ+xP0
         abXJPoRujrpCph6qjRFHRjXRAE+hQxxbqhp3QCicxO5f2QP3L/PvjE7MEYIHfkzn4PtP
         AEeZoIoN0sjlHKcAvLgO3xF3ITPw0AvQ3GitM=
Message-ID: <4A840172.8020707@gmail.com>
Date: Thu, 13 Aug 2009 08:05:06 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: alacrityvm-devel@lists.sourceforge.net,
       alacrityvm-users@lists.sourceforge.net,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
Subject: Re: AlacrityVM numbers updated for 31-rc4
References: <4A83296B.3080606@gmail.com> <4A834ABB.4010801@codemonkey.ws> <4A834E75.9060204@gmail.com>
In-Reply-To: <4A834E75.9060204@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig21D5013D96877AA48AB44C19"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig21D5013D96877AA48AB44C19
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Anthony Liguori wrote:

>> Just FYI, the numbers quoted are wrong for virtio-u.  Greg's machine
>> didn't have high res timers enabled in the kernel.  He'll post newer
>> numbers later but they're much better than these (venet is still ahead=

>> though).
>>
>> Regards,
>>
>> Anthony Liguori
>=20
> Anthony is correct.  The new numbers after fixing the HRT clock issue a=
re:
>=20
> virtio-u: 2670Mb/s, 266us rtt (3764 tps udp-rr)
>=20
> I will update the charts later tonight.
>=20

done


--------------enig21D5013D96877AA48AB44C19
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqEAXIACgkQP5K2CMvXmqEhtwCfcSwKKYWysNLQmF7VISNrNPwl
CkIAniQ8z8sQcIkd/hdeXQhfHuxx1TIa
=jRLu
-----END PGP SIGNATURE-----

--------------enig21D5013D96877AA48AB44C19--
