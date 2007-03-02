Return-Path: <linux-kernel-owner+w=401wt.eu-S2992655AbXCBR1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992655AbXCBR1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992658AbXCBR1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:27:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:57254 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992655AbXCBR1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:27:17 -0500
Date: Fri, 2 Mar 2007 18:27:15 +0100
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ACPI documentation in kernel-parameters.txt
Message-ID: <20070302172715.GA9157@strauss.suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070301231640.GD21440@strauss.suse.de> <ada4pp4mttf.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <ada4pp4mttf.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

* Roland Dreier <rdreier@cisco.com> [2007-03-02 00:23]:
>  > Add hint that acpi=3Doff doesn't work on IA64.
>=20
> Would it make sense to add code to detect this and print a kernel
> message like
>=20
>     warning: ACPI is always enabled on IA64; ignoring "acpi=3Doff"
>=20
> No one reads documentation :)

The idea is not bad, but it should not make sense to have it only for
ACPI and not for other arch-specific options ...


Regards
Bernhard

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF6F5ziGU2lt2vZFQRAp6XAKC4K039WB1eDen0zfDM4KC+3Z1opwCgoSoj
9mTlboVIBMvlAJ1QSxmqdcE=
=Tfdo
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
