Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZHKNsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZHKNsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZHKNsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:48:10 -0400
Received: from bavaria.utcluj.ro ([193.226.5.35]:65203 "EHLO bavaria.utcluj.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZHKNsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:48:10 -0400
X-Greylist: delayed 4202 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Aug 2009 09:48:09 EDT
Subject: [RFC] Multiboot protocol support in vmlinux?
From: Cristi Magherusan <Cristi.Magherusan@net.utcluj.ro>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ff9LW98KudoGMExCFPhV"
Date: Tue, 11 Aug 2009 10:12:29 +0300
Message-Id: <1249974749.3640.11.camel@ufo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ff9LW98KudoGMExCFPhV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Have you considered (optionally) supporting multiboot in the future,
directly in the ELF vmlinux image (not in bzImage as it is now)?

What would be the pros and cons of the current implementation as
compared to multiboot-compatible ELF from your point of view?

Thanks,
Cristi M.

--=20
Ing. Cristi M=C4=83gheru=C8=99an, System/Network Engineer
Technical University of Cluj-Napoca, Romania
http://cc.utcluj.ro  +40264 401247

--=-ff9LW98KudoGMExCFPhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqBGdgACgkQfwrBISYVZFWpQQCcDnbbeMB4l4+0XWvq2ogeJ2fv
PJMAniZRHJEVHqs7JfYuwVkcAn66puj6
=9gRQ
-----END PGP SIGNATURE-----

--=-ff9LW98KudoGMExCFPhV--

