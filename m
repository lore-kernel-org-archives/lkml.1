Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYKJQx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYKJQx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYKJQxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:53:46 -0500
Received: from mx33.mail.ru ([194.67.23.194]:26459 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbYKJQxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:53:45 -0500
X-Greylist: delayed 46655 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2008 11:53:45 EST
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11895] 2.6.28-rc2 regression: keyboard dead after reboot on Toshiba Portege 4000
Date: Mon, 10 Nov 2008 19:53:37 +0300
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Avi Kivity" <avi@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <wnN9HICUAgP.A.5I.V5zFJB@chimera>
In-Reply-To: <wnN9HICUAgP.A.5I.V5zFJB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1703427.C7hSFRD7xb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811101953.38938.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1703427.C7hSFRD7xb
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 09 November 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
>=20

it is fixed in rc4

>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D11895

Could you reassign this to ACPI product so this bug could be further
investigated or should I open seperate one?

--nextPart1703427.C7hSFRD7xb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkYZxIACgkQR6LMutpd94yiXACgrflMkzLbzTblHKx5yOQ9Uuia
y78An0CfjaYBKgP7gf2b5cNju67CwYQ5
=1ICX
-----END PGP SIGNATURE-----

--nextPart1703427.C7hSFRD7xb--
