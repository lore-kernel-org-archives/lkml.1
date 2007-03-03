Return-Path: <linux-kernel-owner+w=401wt.eu-S1751199AbXCCH0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbXCCH0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 02:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXCCH0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 02:26:34 -0500
Received: from scrye.com ([216.17.180.1]:60216 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXCCH0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 02:26:34 -0500
Date: Sat, 3 Mar 2007 00:12:16 -0700
From: Kevin Fenzi <kevin@scrye.com>
To: linux-kernel@vger.kernel.org
Subject: Re: usbserial not working/oops on removal
Message-ID: <20070303001216.0f0fd372@ningauble.scrye.com>
In-Reply-To: <200703030745.19547.oliver@neukum.org>
References: <20070302193715.568098a6@ningauble.scrye.com>
	<200703030745.19547.oliver@neukum.org>
Organization: Scrye
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_dgWbm3fF+gFv+z1LLDn9lii;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_dgWbm3fF+gFv+z1LLDn9lii
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 3 Mar 2007 07:45:19 +0100
oliver@neukum.org (Oliver Neukum) wrote:

> Am Samstag, 3. M=C3=A4rz 2007 03:37 schrieb Kevin Fenzi:
> > I'm seeing some oddity with the latest fedora development kernel
> > and a usbserial device.=20
>=20
> Very interesting. Is this repeatable?=20

Yep. Tried a half dozen times or so... same thing each time.=20

> Does unplugging have the same
> effect?

Well, the card is a minipci, so I would prefer to avoid taking the
machine apart to unplug the card. ;)=20

> 	Regards
> 		Oliver

kevin


--Sig_dgWbm3fF+gFv+z1LLDn9lii
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF6R/T3imCezTjY0ERAr2KAJ9wHJCznHbPtaKkA0MLlEKfIjPc1wCghqt/
1OiPDKwGEjpKgfqPOkyG+5g=
=CKeo
-----END PGP SIGNATURE-----

--Sig_dgWbm3fF+gFv+z1LLDn9lii--
