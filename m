Return-Path: <linux-kernel-owner+w=401wt.eu-S965375AbXAYPPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965375AbXAYPPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXAYPPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:15:53 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41087 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965375AbXAYPPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:15:52 -0500
Message-ID: <45B8C9A3.6060107@drzeus.cx>
Date: Thu, 25 Jan 2007 16:15:47 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-15074-1169738151-0001-2"
To: "Christopher \"Monty\" Montgomery" <xiphmont@gmail.com>
CC: Greg KH <greg@kroah.com>, perex@suse.cz, mclasen@redhat.com,
       jrb@redhat.com, Lennart Poettering <lennart@poettering.net>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       fedora-desktop-list@redhat.com
Subject: Re: [PATCH] alsa: correct nonsensical sysfs device symlinks
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>	 <20070125042616.GA21813@kroah.com> <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>
In-Reply-To: <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-15074-1169738151-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christopher "Monty" Montgomery wrote:
>=20
> My machines and the fedora rawhide machines using the 2.6.20-rcX
> releases look nothing like what you pasted.  If they did, hald would
> be working...  (I'll note that bugs have also been logged against
> Pulse and HAL by users having trouble, so it's not just us.)

On my vanilla 2.6.20-rc5, I get the same structure as Greg. Yet hal
still doesn't pick stuff up as it should.

Rgds
Pierre



--=_hera.drzeus.cx-15074-1169738151-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFuMmm7b8eESbyJLgRAqFZAKDopl+cjrHCZioft8A4U8ZtzDq/WQCgzgxw
hLnWlIwJKEIhgo7+GYnrY6w=
=4jgf
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-15074-1169738151-0001-2--
