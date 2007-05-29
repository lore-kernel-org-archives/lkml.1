Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXE2Olb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXE2Olb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXE2OlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:41:24 -0400
Received: from iucha.net ([209.98.146.184]:47848 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbXE2OlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:41:24 -0400
Date: Tue, 29 May 2007 09:41:20 -0500
To: Jan Kara <jack@suse.cz>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Thierry Volpiatto <tvolpiatt@neuf.fr>,
       alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, Ben Collins <bcollins@ubuntu.com>,
       linux-fsdevel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [1/4] 2.6.22-rc3: known regressions
Message-ID: <20070529144120.GC17474@iucha.net>
References: <465C2225.2000100@googlemail.com> <20070529143459.GE25278@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Content-Disposition: inline
In-Reply-To: <20070529143459.GE25278@duck.suse.cz>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 29, 2007 at 04:34:59PM +0200, Jan Kara wrote:
> On Tue 29-05-07 14:52:53, Michal Piotrowski wrote:
> > Here is a list of some known regressions in 2.6.22-rc3.
> >=20
> > Subject    : Oops in dentry_iput with 2.6.22-rc2 on AMD64
> > References : http://lkml.org/lkml/2007/5/22/4
> > Submitter  : Florin Iucha <florin@iucha.net>
> > Status     : Unknown
>   Actually, the bug seems to be unreproducible and it has probably been a
> 1-bit flip. So I'd be reluctant to call it a regression...

I agree with this statement.  I'll ping Michal and Jan if the oops
resurfaces.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGXDuQND0rFCN2b1sRAqIhAJ4s/oxJ8GixFXZuJ7FuFLWhuPoelACfYby5
hBfO3k4IafmLhzKeXGBluZI=
=799Z
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
