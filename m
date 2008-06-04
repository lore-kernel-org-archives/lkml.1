Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYFDAET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYFDAET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYFDAEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:04:10 -0400
Received: from cpsmtpo-eml05.kpnxchange.com ([213.75.38.154]:24507 "EHLO
	cpsmtpo-eml05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYFDAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:04:10 -0400
From: Frans Pop <elendil@planet.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: [BUG] 2.6.26-rc1 broke X on SPARC Ultra5
Date: Wed, 4 Jun 2008 02:04:02 +0200
User-Agent: KMail/1.9.9
Cc: airlied@gmail.com, mikpe@it.uu.se, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080603.062253.17158135.davem@davemloft.net> <18501.39659.952880.727014@alkaid.it.uu.se> <21d7e9970806031345u4e7838fdp60bbedadd65b5f2a@mail.gmail.com> <21d7e9970806031345u4e7838fdp60bbedadd65b5f2a@mail.gmail.com> <20080603.135449.193702216.davem@davemloft.net>
In-reply-To: <20080603.135449.193702216.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1507514.Ml7E7E0bAx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200806040204.03518.elendil@planet.nl>
X-OriginalArrivalTime: 04 Jun 2008 00:04:05.0566 (UTC) FILETIME=[80DC65E0:01C8C5D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1507514.Ml7E7E0bAx
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

David Miller wrote:
> Meanwhile X itself shipped mostly-non-working for PCI devices on sparc
> for years.  And would you also not argue that it's broken to begin
> with that the older X servers cannot work properly without a root PCI
> controller being there?

I can relate to that as starting X at one point ate the partition table on=
=20
both my harddrives due to a PCI handling bug :-/
=20
I assume this is not an issue with X.Org 7.3 (which is what Debian Lenny=20
will probably release with)?

> I'm the only sparc64 platform developer, so my time is better spent
> moving forward and making sure that libpciaccess based X servers
> aren't so broken and do the right thing in a way which works in a
> maintainable long term manner.

=46rom my limited perspective: agreed. And thanks for all the work you do.

Cheers,
=46JP

--nextPart1507514.Ml7E7E0bAx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIRdvzgm/Kwh6ICoQRAmAdAKDao8akwS/hfR3mmhhFaRfeSzrwagCgqBb5
VJl8NieSGu7Q8/j5892C0f0=
=E75n
-----END PGP SIGNATURE-----

--nextPart1507514.Ml7E7E0bAx--
