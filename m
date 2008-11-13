Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYKMRLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYKMRLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYKMRLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:11:06 -0500
Received: from os.eurotux.com ([216.75.63.6]:41820 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYKMRLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:11:05 -0500
Date: Thu, 13 Nov 2008 17:10:57 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
Message-ID: <20081113171057.GA3223@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux-Kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	SCSI development list <linux-scsi@vger.kernel.org>
References: <20081105102614.GB3586@bit.office.eurotux.com> <Pine.LNX.4.44L0.0811051149500.2187-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811051149500.2187-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2008 at 11:51:41AM -0500, Alan Stern wrote:
> On Wed, 5 Nov 2008, Luciano Rocha wrote:
>=20
> > > Please rerun the A+B and A+B+C tests, but this time using the B' patch
> > > below instead of B.
> >=20
> > New test data in the bugzilla.
>=20
> Sorry, dumb mistake on my part.  B'' is below.  It is the same as B'=20
> except for one character.

A+B''+C seems to have done it. The bugzilla entry was updated with the
kernel messages and usb traffic.

  http://bugzilla.kernel.org/show_bug.cgi?id=3D11843

Regards,
Luciano Rocha

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkcX6EACgkQinSul6a7oB96NACdEkdPb1R6y4blXdb4jb5W/D8L
9YIAn3pTsHyx8+yPc/bjLpvzemdFDLex
=erlF
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
