Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbXGER7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbXGER7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760011AbXGER7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:59:23 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2626 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759426AbXGER7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:59:22 -0400
Date: Thu, 5 Jul 2007 19:57:35 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: John Stoffel <john@stoffel.org>
Cc: Theodore Tso <tytso@mit.edu>, alan <alan@clueserver.org>,
       J?rn Engel <joern@logfs.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070705175735.GC5179@gateway.home>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618140143.GD30244@thunk.org> <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org> <20070618172955.GB24189@thunk.org> <20070704173234.GB26201@gateway.home> <18060.63700.223173.537189@stoffel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <18060.63700.223173.537189@stoffel.org>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 05, 2007 at 09:57:40AM -0400, John Stoffel wrote:
> >>>>> "Erik" =3D=3D Erik Mouw <mouw@nl.linux.org> writes:
> Erik> The only valid use of Streams in Windows I've seen was a virus
> Erik> checker that stored a hash of the file in a separate
> Erik> stream. Checking a file was a matter of rehashing it and
> Erik> comparing against the hash stored in the special hash data
> Erik> stream for that particular file.
>=20
> So what was stopping a virus from infecting a file, re-computing the
> hash and pushing the new hash into the stream? =20

Nothing, but the same holds for virus checkers that store the hash in a
separate file. The only advantage of storing the hash in a stream is
that the stream is automatically deleted when you remove the file.

> You need to keep the computed hashes on Read-Only media for true
> security, once you let the system change them, then you're toast....

Agreed.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGjTEP/PlVHJtIto0RAtxhAKCGWuhhDHPcJQkd0IpAreWpsWPhfQCdEr6f
NrVyySmp524FDsb7O8GgceY=
=jqMD
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
