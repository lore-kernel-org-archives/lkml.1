Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbZKDKQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbZKDKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZKDKQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:16:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33169 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZKDKQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:16:56 -0500
Date: Wed, 4 Nov 2009 21:16:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: linux-next: pcmcia tree build failure
Message-Id: <20091104211655.97232be9.sfr@canb.auug.org.au>
In-Reply-To: <20091104080754.GA27784@isilmar.linta.de>
References: <20091104131540.f39af556.sfr@canb.auug.org.au>
	<20091104080754.GA27784@isilmar.linta.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__4_Nov_2009_21_16_55_+1100_+YNuZDVRMDCg8erg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Nov_2009_21_16_55_+1100_+YNuZDVRMDCg8erg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dominik,

On Wed, 4 Nov 2009 09:07:54 +0100 Dominik Brodowski <linux@dominikbrodowski=
.net> wrote:
>
> Thanks -- fixed both issues (build failure and test setup).

Thanks for that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__4_Nov_2009_21_16_55_+1100_+YNuZDVRMDCg8erg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrxVJcACgkQjjKRsyhoI8yZ+QCfYi9q3IJk7D7gq1PACwCfEFhT
EpgAmwcwFGWfitbPPxufG7oX9yYYihV4
=C7k6
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Nov_2009_21_16_55_+1100_+YNuZDVRMDCg8erg--
