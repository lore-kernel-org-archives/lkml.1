Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYGGJys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYGGJys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 05:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYGGJyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 05:54:41 -0400
Received: from n32.bullet.mail.mud.yahoo.com ([68.142.201.24]:43795 "HELO
	n32.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752134AbYGGJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:54:40 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 05:54:40 EDT
X-Yahoo-Newman-Id: 64282.18438.bm@omp419.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type;
  b=n9+wCqdnqjOYtEN8F2hIbPtf7hcWc9Wa9RVx70izAJmyRPVhsNpNXWcP6U1Gy5oV6wjSl3hL2r2mjviCOHrsllZUknHfu+hKMr/rWlVd0IOlIOnvNS/2ITkRxP2ozSccCil0QBdW7hEvrlQ5Qa1TgbXZfThAdp7p+TDU9kzUero=  ;
X-YMail-OSG: kZxRlcgVM1llOpUfrvYPWsNO37DqWhwwf0HX7JXrHrbDULBJqA_JajsAWUw0FBg_16DxtsBMjQR.ropVZEAMLcfOflBjn1nkSroJKvqC_YEXv85Oz7iEJDIZy1tgNAoW7w0EJ28Pp5WphGg1ZvgsXpHIg4_8teuOn8I1Ospi15Q-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4871E67A.1040600@yahoo.it>
Date: Mon, 07 Jul 2008 11:48:42 +0200
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Battery life difference
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com> <20080705082352.4b6be669@infradead.org> <31e679430807050844r30ff74fby7e15641573b42d82@mail.gmail.com> <20080706172159.GA12736@x61>
In-Reply-To: <20080706172159.GA12736@x61>
X-Enigmail-Version: 0.95.6
OpenPGP: id=6C1F2F2F;
	url=http://keyserver.fabbione.net:11371/pks/lookup?op=get&search=0x8F3C4C1B6C1F2F2F
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA532BFD3741BA59E2091A315"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA532BFD3741BA59E2091A315
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/07/2008 19:21, Tino Keitel wrote:
> On Sat, Jul 05, 2008 at 18:44:21 +0300, Felipe Balbi wrote:
>> Hi,
>>
>> On Sat, Jul 5, 2008 at 6:23 PM, Arjan van de Ven <arjan@infradead.org>=
 wrote:
>=20
> [...]
>=20
>>> Also take a look at
>>> http://kerneltrap.org/mailarchive/linux-kernel/2008/5/8/1771024 becau=
se
>>> these patches save like 0.75W in our lab.
>> cool, is it merged upstream ?
>=20
> If I got this right, at least Linux 2.6.25 allows to control this via
> "/sys/class/scsi_host/host*/link_power_management_policy". Setting it
> to "min_power" does the trick. This is also covered by powertop 1.10
> and later.

I cannot see this on 2.6.25.9. Is there a particular configuration option=

you must enable, or it just didn't make it to 2.6.25?

Thanks.
Regards.

--=20
Filippo Zangheri

GPG key ID: 0x6C1F2F2F


--------------enigA532BFD3741BA59E2091A315
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIceaAjzxMG2wfLy8RAqsUAJ9pEDT8CVG28VSO9H8YfcUJvPbqrgCeOUiG
YvEuPTwS5Di8hpdMylXRERQ=
=PrjA
-----END PGP SIGNATURE-----

--------------enigA532BFD3741BA59E2091A315--

