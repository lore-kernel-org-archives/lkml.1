Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZBCT3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZBCT3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZBCT2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:28:32 -0500
Received: from cobija.connexer.com ([66.93.22.232]:39972 "EHLO
	cobija.connexer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbZBCT2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:28:31 -0500
X-Greylist: delayed 1939 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 14:28:31 EST
Date: Tue, 3 Feb 2009 19:51:17 +0100
From: sean finney <seanius@seanius.net>
To: Paul Menage <menage@google.com>, Gustavo Noronha <kov@debian.org>,
       debian-devel@lists.debian.org, linux-kernel@vger.kernel.org
Subject: Re: cgroup mount point
Message-ID: <20090203185117.GB3359@mini-me.seanius.net>
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <20090203102416.GA8886@redhat.com> <87ljsnzo4v.fsf@benfinney.id.au> <1233671913.8902.53.camel@abacate.horta> <6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com> <20090203184915.GA10004@glandium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <20090203184915.GA10004@glandium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 03, 2009 at 07:49:15PM +0100, Mike Hommey wrote:
> > Having one virtual filesystem mounted on top of another virtual
> > filesystem seems like a recipe for problems.
>=20
> Like with /sys/fs/fuse/connections ? Come on, there is no problem with a
> virtual filesystem mounted on top of another.

or /proc/bus/usb or /dev/shm or /dev/pts... :)


	sean

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJiJIlynjLPm522B0RAnn0AJ44TJ1aJXSPiFBDv6OGaTl34eKsywCdH90n
dCdoZh7FfpKHwUsWCv/i4Ok=
=ak5U
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
