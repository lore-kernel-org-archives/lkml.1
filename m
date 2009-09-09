Return-Path: <linux-kernel-owner+w=401wt.eu-S1751557AbZIIFqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbZIIFqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 01:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZIIFqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 01:46:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60970 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZIIFqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 01:46:07 -0400
Date: Wed, 9 Sep 2009 15:45:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: linux-next: acpi tree build failure
Message-Id: <20090909154558.dcc64eb9.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0909082359480.20206@localhost.localdomain>
References: <20090901125748.fb33b2ea.sfr@canb.auug.org.au>
	<20090907234612.078bb650.sfr@canb.auug.org.au>
	<1252370869.3483.420.camel@rzhang-dt>
	<alpine.LFD.2.00.0909082359480.20206@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Sep_2009_15_45_58_+1000_tbMS8Z1kqxwYhtbk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Sep_2009_15_45_58_+1000_tbMS8Z1kqxwYhtbk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Wed, 09 Sep 2009 00:02:03 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:
>
> > please revert the two ALS patches.
>=20
> done.
>=20
> Sorry about the merge-conflict and build error, Stephen.
> You can update to the latest acpi-test tree now.

Thanks, I will pick it up tomorrow.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Sep_2009_15_45_58_+1000_tbMS8Z1kqxwYhtbk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqnQRYACgkQjjKRsyhoI8y48gCfWtsmHoj1/yRyG5HDkMaIObOq
/MwAoKPn1fW1ZoRksFGNM4ywEvqDfpRB
=cPQI
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Sep_2009_15_45_58_+1000_tbMS8Z1kqxwYhtbk--
