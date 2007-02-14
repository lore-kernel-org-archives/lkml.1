Return-Path: <linux-kernel-owner+w=401wt.eu-S932144AbXBNKki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbXBNKki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbXBNKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:40:37 -0500
Received: from lug-owl.de ([195.71.106.12]:47974 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144AbXBNKkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:40:10 -0500
Date: Wed, 14 Feb 2007 11:40:08 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: "Ramy M. Hassan " <ramy@gawab.com>
Cc: linux-kernel@vger.kernel.org, Ahmed El Zein <a.elzein@gawab.net>
Subject: Re: xfs internal error on a new filesystem
Message-ID: <20070214104008.GY23849@lug-owl.de>
Mail-Followup-To: "Ramy M. Hassan " <ramy@gawab.com>,
	linux-kernel@vger.kernel.org, Ahmed El Zein <a.elzein@gawab.net>
References: <20070214102432.6346.qmail@info6.gawab.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L4xCDQ7GT+ph8Lmk"
Content-Disposition: inline
In-Reply-To: <20070214102432.6346.qmail@info6.gawab.com>
X-Operating-System: Linux mail 2.6.12.3lug-owl 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--L4xCDQ7GT+ph8Lmk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-14 10:24:27 +0000, Ramy M. Hassan  <ramy@gawab.com> wrote:
> Feb 14 08:28:52 info6 kernel: [238186.945610] Filesystem "sdd8": Corrupti=
on of in-memory data detected.  Shutting down filesystem: sdd8
[...]
> We are wondering here if this problem is an indicator to data corruption =
on
> disk ? is it really necessary to run xfs_repair ?  Do u recommend that we
> switch back to reiserfs ? Could it be a hardware related problems  ? any
> clues how to verify that ?

Running memtest86 for some hours could at least help to verify that
you don't see bad memory...

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of: 23:53 <@jbglaw> So, ich kletter' jetzt mal ins Bett.
the second  : 23:57 <@jever2> .oO( kletter ..., hat er noch Gitter vorm Bet=
t, wie fr=C3=BCher meine Kinder?)
              00:00 <@jbglaw> jever2: *patsch*
              00:01 <@jever2> *aua*, wof=C3=BCr, Gedanken sind frei!
              00:02 <@jbglaw> Nee, freie Gedanken, die sind seit 1984 doch =
aus!
              00:03 <@jever2> 1984? ich bin erst seit 1985 verheiratet!

--L4xCDQ7GT+ph8Lmk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF0ucIHb1edYOZ4bsRAkDJAKCMkiCchWv/c9oDtYXR92IEk1q9WwCdGTK+
jBlSXdokeOxqRBUDfpaM+LE=
=sQdE
-----END PGP SIGNATURE-----

--L4xCDQ7GT+ph8Lmk--
