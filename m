Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZHOIAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZHOIAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 04:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZHOIAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 04:00:00 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZHOH77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 03:59:59 -0400
Subject: Re: [PATCH v4 34/34] wireless: mark prism54.ko as deprecated and
 mark for removal
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       Larry.Finger@lwfinger.net, aquilaver@yahoo.com,
       linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
       Kai Engert <kengert@redhat.com>, Jean Tourrilhes <jt@hpl.hp.com>,
       Tim de Waal <tim.dewaal@yahoo.com>, Roy Marples <uberlord@gentoo.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christian Lamparter <chunkeey@web.de>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <1250281559-13041-35-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	 <1250281559-13041-35-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tv9P+t3g7Muy8KHLHc/m"
Date: Sat, 15 Aug 2009 09:59:42 +0200
Message-Id: <1250323182.15069.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tv9P+t3g7Muy8KHLHc/m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-14 at 16:25 -0400, Luis R. Rodriguez wrote:
> The preferred modules is p54.ko, which also supports FullMAC
> PCI / Cardbus devices. We schedule removal for 2.6.34. Reason
> to remove this is no one really is testing prism54.ko anymore,
> and while it works p54.ko provides support for the same hardware.
> It should be noted I have been told some FullMAC devices may not
> have worked with the SoftMAC driver but to date we have yet to
> recieve a single bug report regarding this. If there are users
> out there please let us know!

Not that I care about the changelog, but I do find it illogical to refer
to modules w/o .ko everywhere and then with .ko in the changelog. Of
course you were consistent ;)

> -	  The module will be called prism54.
> +	  When built as module you get prism54.ko

NAK this change.

johannes

--=-tv9P+t3g7Muy8KHLHc/m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhmrqAAoJEODzc/N7+QmafhgQAI17nxRmHFThE0ajfM/SGrir
rWISfI+9Pi/dqtIXdKlR8fsT34mzd8NkJ+9dn9pGNren+r4fUTwhr6SiSRzqmwcg
e7qNC6XUSW8Kh3sByc73upexIthLoNnqvuVQVRRvJA3ghNd4KuBklilGqxe7FtL/
igVintQkCrlAiX/d/16ci91QvbC9Po+dWfd/cZ/FM6yeTtTVfqLvKCl86ZVA+w6l
dmJtqYznSiWdl1KHOu9FNw7FC2vgKfShrGGqVmK4ZKTHDHSx3+BqYywfC4FukaLc
f14nUvTB+hdjr93USlXAqgbF7P4dTMOilVa6pHubur4s6mHbP3INaQoeVGGDX8l/
1uPSu2KbTY+KI72d0brGKT5bdRdXh8qZxqKRDQekNVDST0AuSx3uqVGF9XYNdMe9
7In56uXHiPPoKXMNN3hGoHjumKTf78E6Cma/PqZ6oDNEF2N7XSAJXkeVbzld8U81
h5fnC0uL6oPQndnZNwipS/5HPxoN3nWc2Chxd8xrJ3/ac6fYfUJ0Tbdl+9wioPMQ
lZUqRn4zaWaPr/JjuhUl1L4NvOY4JUsnZ5faDEFj3cJs4fTXPt1tmzrokjRxFxqv
nD0bqgUtVZp/aFq79VUYdYRgGKzK83TZPDPL1+asOic21awmWhZQtK9kxAX8PTC1
8JSpL19aZsThN+YHRU+C
=Vze7
-----END PGP SIGNATURE-----

--=-tv9P+t3g7Muy8KHLHc/m--

