Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbXIKWGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbXIKWGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 18:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761702AbXIKWFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 18:05:55 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:56199 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761438AbXIKWFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 18:05:53 -0400
Date: Wed, 12 Sep 2007 01:05:46 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
Message-ID: <20070911220545.stsrosz56s64376n@m.safari.iki.fi>
Mail-Followup-To: Lee Revell <rlrevell@joe-job.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	lkml <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>, jgarzik <jgarzik@pobox.com>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com> <1189532202.21778.84.camel@twins> <75b66ecd0709111138xb5f6120qee40345378b188eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gwjewavp5n33fiot"
Content-Disposition: inline
In-Reply-To: <75b66ecd0709111138xb5f6120qee40345378b188eb@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-09-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--gwjewavp5n33fiot
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2007 at 14:38:13 -0400, Lee Revell wrote:
> You can also diff -Nru old.c new.c | xclip, select Preformat, then
> paste with the middle button.

mutt does not come with text editor, so
I'd like to add note about vim:

If using xclip, type command
:set paste
before middle button or shift-insert or use
:r filename

=2E..if you want to include patch inline.
(a)ttach works fine without "set paste".

--=20
Do what you love because life is too short for anything else.


--gwjewavp5n33fiot
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFG5xE5MCYCLUwuV18RApyEAJwJWdwW3nzqWmhOUcSzN4CYmn90awCdGk35
Cf/aXrnmELduvWXymNS1eOA=
=6P5Y
-----END PGP SIGNATURE-----

--gwjewavp5n33fiot--
