Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZHaTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZHaTCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZHaTCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:02:17 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:53503
	"EHLO QMTA15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbZHaTCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:02:16 -0400
Date: Mon, 31 Aug 2009 14:02:09 -0500
From: Tim Walberg <twalberg@comcast.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tim Walberg <twalberg@comcast.net>, Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs compat_ioctl?
Message-ID: <20090831190209.GD19343@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
Mail-Followup-To: Tim Walberg <twalberg@comcast.net>,
	Christoph Hellwig <hch@infradead.org>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
References: <4A9B759B.7020401@msgid.tls.msk.ru> <20090831123010.GA2368@infradead.org> <20090831183751.GC19343@comcast.net> <20090831184822.GA10393@infradead.org> <20090831184918.GB10393@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline
In-Reply-To: <20090831184918.GB10393@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



On 08/31/2009 14:49 -0400, Christoph Hellwig wrote:
>>	On Mon, Aug 31, 2009 at 02:48:22PM -0400, Christoph Hellwig wrote:
>>	> On Mon, Aug 31, 2009 at 01:37:51PM -0500, Tim Walberg wrote:
>>	> > Linux sparcy 2.6.30.4-sparcy #2 Sat Aug 1 21:14:46 CDT 2009 sparc64 =
GNU/Linux
>>	> > sparcy:~# file $(which xfs_fsr)
>>	> > /usr/sbin/xfs_fsr: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Requi=
red, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux=
 2.6.18, stripped
>>	>=20
>>	> I'll take a look at that, thanks.
>>=09
>>	Err, sorry - is that with the patch I posted in this thread or without?
End of included message


No, that's the generic 2.6.30.4... I can attempt with that patch as well, b=
ut
it might be a day or two...

				tw


--=20
+----------------------+
| Tim Walberg          |
| 830 Carriage Dr.     |
| Algonquin, IL 60102  |
| twalberg@comcast.net |
+----------------------+

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqcHjEACgkQw+Wcj22rJWafGgCfezgV5i6D9BQzkaIjuDF2OaGe
OPMAoL74DPQlOVe+jY1lAVjM+lrj5bDJ
=ucVX
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
