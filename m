Return-Path: <linux-kernel-owner+w=401wt.eu-S1030382AbXBTUaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030382AbXBTUaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 15:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965122AbXBTUaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 15:30:25 -0500
Received: from lug-owl.de ([195.71.106.12]:42909 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965074AbXBTUaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 15:30:24 -0500
Date: Tue, 20 Feb 2007 21:30:23 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: v j <vj.linux@gmail.com>, davids@webmaster.com, trent.waddington@gmail.com,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070220203023.GB9712@lug-owl.de>
Mail-Followup-To: Helge Hafting <helge.hafting@aitel.hist.no>,
	v j <vj.linux@gmail.com>, davids@webmaster.com,
	trent.waddington@gmail.com,
	"Michael K. Edwards" <medwards.linux@gmail.com>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	Neil Brown <neilb@suse.de>
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com> <9b3a62ab0702192119l1bf9a284la93c9d1f01638ca4@mail.gmail.com> <45DB0788.1000600@aitel.hist.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <45DB0788.1000600@aitel.hist.no>
X-Operating-System: Linux mail 2.6.12.3lug-owl 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-20 15:36:56 +0100, Helge Hafting <helge.hafting@aitel.hist.=
no> wrote:
> If you have a need for "secret" source code, stuff most of it
> in userspace.  Make the drivers truly minimal; perhaps their
> open/closed status won't matter that much when the bulk
> of the code and the cleverness is kept safe in userspace.
>=20
> Note that keeping drivers small this way is the recommended
> way of working anyway. It isn't merely a way to keep your
> code away from the GPL - you always want a small kernel.

Keeping the legal stuff out of sight for a second, this'll solve the
"problem" for the embedded developer, but surely not for the Linux
community. Would you ever expect that eg. the thin GPL layer used by
ATI/NVidia would be merged iff the rest would run in userland?

It's just a workaround for the
linking-the-object-file-into-the-kernel-image problem, but after all,
it doesn't lead to a working driver being freely available.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
 Signature of:                            If it doesn't work, force it.
 the second  :                   If it breaks, it needed replacing anyway.

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF21pfHb1edYOZ4bsRAkrmAJ9zrBMXVvZYY+HNm/yjRY5nG8IhGACfRLaO
z8djPgnty7ZQXuAeKaS9UuE=
=h8F2
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
