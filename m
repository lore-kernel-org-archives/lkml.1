Return-Path: <linux-kernel-owner+w=401wt.eu-S934589AbZLPC3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589AbZLPC3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934560AbZLPC27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:28:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40572 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934558AbZLPC26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:28:58 -0500
Date: Wed, 16 Dec 2009 13:28:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: acpi tree build failure
Message-Id: <20091216132847.c32ab30e.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0912151736290.6885@localhost.localdomain>
References: <20091214122013.a869739e.sfr@canb.auug.org.au>
	<1260853054.21292.10.camel@dc7800.home>
	<alpine.LFD.2.00.0912151736290.6885@localhost.localdomain>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Dec_2009_13_28_47_+1100_q0+2Oa0/UuW07Y6P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Dec_2009_13_28_47_+1100_q0+2Oa0/UuW07Y6P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Tue, 15 Dec 2009 17:37:21 -0500 (EST) Len Brown <lenb@kernel.org> wrote:
>
> i merged bjorn's fix into the original offending patch in acpi-test

That didn't seem to be in what I fetched for linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Dec_2009_13_28_47_+1100_q0+2Oa0/UuW07Y6P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksoRd8ACgkQjjKRsyhoI8xEcACZAV+Kv119iFV1zbOlJNSXOdF2
MsMAn1urkpPQ9kWZ0/D96bNGgucX2zEY
=NvgX
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Dec_2009_13_28_47_+1100_q0+2Oa0/UuW07Y6P--
