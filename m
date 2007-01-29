Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbXA2PHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbXA2PHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbXA2PHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:07:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbXA2PHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:07:21 -0500
Message-ID: <45BE0D98.7020005@redhat.com>
Date: Mon, 29 Jan 2007 07:07:04 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@openvz.org>
CC: Andrew Morton <akpm@osdl.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lutimesat: actual syscall and wire-up on i386
References: <20070126112345.GC11128@localhost.sw.ru> <20070126123903.046aaa5e.akpm@osdl.org> <45BA6860.6040007@redhat.com> <20070129110509.GA13096@localhost.sw.ru>
In-Reply-To: <20070129110509.GA13096@localhost.sw.ru>
X-Enigmail-Version: 0.94.1.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig465D7568B1038B4E09D962BB"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig465D7568B1038B4E09D962BB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Alexey Dobriyan wrote:
> What do you mean by "filesystems cannot support lutimes"? Filesystems
> that don't have on-disk timestamps for symlinks?

Yes.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig465D7568B1038B4E09D962BB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFvg2Z2ijCOnn/RHQRAqxgAJ9INW8gWbOxGwpxZqr6C2/iBGBiPgCeP3jJ
R3jTCZj0fMnlQfIaBw4dajU=
=7268
-----END PGP SIGNATURE-----

--------------enig465D7568B1038B4E09D962BB--
