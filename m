Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbZGABfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbZGABfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbZGABfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:35:04 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:46703 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZGABfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:35:03 -0400
Date: Tue, 30 Jun 2009 21:35:04 -0400
From: Stephen Frost <sfrost@snowman.net>
To: dann frazier <dannf@dannf.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, David Altobelli <david.altobelli@hp.com>,
       nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090701013504.GE20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <20090628172052.GA13957@ldl.fc.hp.com> <20090628223258.GP20436@tamriel.snowman.net> <20090630011541.GL22480@ldl.fc.hp.com> <20090630011709.GT20436@tamriel.snowman.net> <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com> <20090630015140.GV20436@tamriel.snowman.net> <20090630015302.GN22480@ldl.fc.hp.com> <20090630020644.GW20436@tamriel.snowman.net> <20090630193050.GA9496@lackof.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="caC6Ojpb5aKGbDVu"
Content-Disposition: inline
In-Reply-To: <20090630193050.GA9496@lackof.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 21:34:38 up 19 days, 23:01, 22 users,  load average: 0.09, 0.10,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--caC6Ojpb5aKGbDVu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* dann frazier (dannf@dannf.org) wrote:
> On Mon, Jun 29, 2009 at 10:06:44PM -0400, Stephen Frost wrote:
> > Don't suppose you can grab a P600 from somewhere and try?
>=20
> Got one, and I am able to reproduce a hang while initializing
> cciss. I'll try narrowing down the issue.

Great!  Glad to hear it.  If there's anything I can do to help, please
let me know.

	Thanks,

		Stephen

--caC6Ojpb5aKGbDVu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpKvUgACgkQrzgMPqB3kihlegCffyHNdeeu4JG3YgOfKh47PYX9
BLQAnjmDFuK5xKyTphUxS+tERPZlO1JL
=qNLx
-----END PGP SIGNATURE-----

--caC6Ojpb5aKGbDVu--
