Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbXKQFSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbXKQFSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 00:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXKQFSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 00:18:10 -0500
Received: from hu-out-0506.google.com ([72.14.214.229]:33455 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXKQFSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 00:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=iZfJu+B1QIMbiOhBmdD5ryUlmGAmJsNVIqrm0Ur52VJX8KauoXc2I9K2PJLJlQZvpxldmqPSUnadGLbqc/oNMw/VsFQs6/hGARVoox0IIWLsLjMXxS3cvX7XM/4sr8aT91npsBwbnnmq7wBYqVIOab5SrMx8k9c7e+PShCLlyJE=
Date: Sat, 17 Nov 2007 05:17:56 +0000
From: ewanm89 <ewanm89@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: distro specific kernels vs vanilla kernel and how to compare
 among each other
Message-ID: <20071117051756.4b1d20da@ewanm89-laptop>
In-Reply-To: <p73tznlbzfs.fsf@bingen.suse.de>
References: <2089856624@web.de>
 <p73tznlbzfs.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_pyhLRd8Z0ojbXKQ1uwtRm1L;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_pyhLRd8Z0ojbXKQ1uwtRm1L
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Nov 2007 23:25:27 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> devzero@web.de writes:
>=20
> > does somebody know if there is a website or a project for giving
> > comfortable and deeper insight into what`s specific to distro`s
> > kernels and what`s their difference to vanilla kernel ?
> >
> > i mean some way to have some transparancy to what different distro
> > vendors add to vanilla kernel sources and thus turning it into
> > their own specific version.=20
>=20
> There used to be such a page at kernelnewbies, but at some point it
> disappeared.
>=20
> I agree it would be a useful resource.
>=20
> -Andi
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I would also like to see something like this, as some work I'm doing on
working some funny networking (unfortunately IT department don't have
common sense) across multiple distros. Tracking the kernel patche
differences between the distros seems to be the hardest part (comparing
them to find what's needed for all distros to work).

--=20
Ewan Marshall (ewanm89)

Geek by nature, Linux by choice.

--Sig_pyhLRd8Z0ojbXKQ1uwtRm1L
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHPnmJD0+JBIHfEBMRAvHtAKDpSXa3j+KNTae4E6r4Cu8QNTcwewCg6Hds
+/IPeDZ7P1eVFdzpk5mtga8=
=nNv7
-----END PGP SIGNATURE-----

--Sig_pyhLRd8Z0ojbXKQ1uwtRm1L--
