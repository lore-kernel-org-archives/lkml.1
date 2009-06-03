Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbZFCRdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbZFCRdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZFCRdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:33:32 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:52803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbZFCRdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:33:31 -0400
Subject: Re: linux-next: Tree for June 3 (rfkill)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       linux-wimax@intel.com, wimax@linuxwimax.org
In-Reply-To: <4A26B0D2.3090207@oracle.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
	 <4A269539.8020607@oracle.com>  <4A26B0D2.3090207@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GeECyou/NqU0JF9rluOW"
Date: Wed, 03 Jun 2009 19:33:20 +0200
Message-Id: <1244050400.22105.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GeECyou/NqU0JF9rluOW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 10:20 -0700, Randy Dunlap wrote:

> Ugh, there are similar errors in the wimax area, which doesn't
> seem to mention RFKILL in its Kconfig file at all.  :(

Guess it too will have to get a

	depends on RFKILL || !RFKILL

I can take care of it after dinner.

johannes

--=-GeECyou/NqU0JF9rluOW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJrPdAAoJEODzc/N7+QmaN/sP/iBHXVPwc/uhbzWEuk4LNvkE
SJo9RFxFHA4ALCCkCfp9VZL3jtws5BABBdNJxvRN3nUMnQehmANfCAiRtbAOqr3Y
xsE2nMDmJzZKIKpp4LMQUMN0HMa/PK6S8S5VJlPG/KsPZDzerw22kk/Kf9o8Wdoc
Juag+qtk8H7alIyyI0JGuatN/szikDdzIvq+BKsKfe3Y6hPRcA/VvF1tl9Wn2l+t
75BOwYZQyXYPsE0bDgWXkWctau6OHec35RU9afnUFUQTrlRPqs5TzjadVcXHWXvE
2oaa9B72LBxpHMutSuCsvGELvWf88GXw9VXU4cXoZ9GkhXsW6jSWGyAhsSeACKTH
KoGVQsgEJi87HkHCH8O9ORneK+1Hcc70R/Z4p3e6/jV9ialByNpoeR+zfcRnlRWA
WcINYmbGl5Ak4GaAftdJKEqKlimle8MvKtOXxPc5Q1NH6uFj3iivLGJa7F8IAp2x
/th/exuhe9LcbbxvHV/4c7s3npG1ndfhD94UeTyozmXHszo3FFWnBFMWuZobqtgb
jSL000TjVaTtU+ZjoUl99ZDq5FIEELnnnCit4MmsdeKwkrZnnuUJAmXqCp/wikv0
VkkQY01yMIRSEMSzIjK8vtfgzpc/q9EPrCmQ4h/zGpk62KqUiMR4anR2t5l+UQrY
Se8CSndSgefpfF7+z5XF
=cJyO
-----END PGP SIGNATURE-----

--=-GeECyou/NqU0JF9rluOW--

