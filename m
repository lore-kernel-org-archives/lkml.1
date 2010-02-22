Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0BVPSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:18:12 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:50126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab0BVPSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:18:08 -0500
Subject: Re: [PATCH 1/2] Document the rfkill sysfs ABI
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, florian@mickler.org,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20100222150006.GA2988@tuxdriver.com>
References: <1266702045-6062-1-git-send-email-florian@mickler.org>
	 <1266702045-6062-2-git-send-email-florian@mickler.org>
	 <1266704345.32739.0.camel@jlt3.sipsolutions.net>
	 <1266746930.18491.1.camel@violet>  <20100222150006.GA2988@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/s4UwWFRmUZYtFD+85yu"
Date: Mon, 22 Feb 2010 16:17:57 +0100
Message-ID: <1266851877.23882.67.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/s4UwWFRmUZYtFD+85yu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-22 at 10:00 -0500, John W. Linville wrote:
> On Sun, Feb 21, 2010 at 11:08:50AM +0100, Marcel Holtmann wrote:
> > Hi Johannes,
> >=20
> > > > This moves sysfs ABI info from Documentation/rfkill.txt to the
> > > > ABI subfolder and reformats it.
> > > >=20
> > > > Signed-off-by: Florian Mickler <florian@mickler.org>
> > >=20
> > > This is fine with me.
> >=20
> > we have to be careful here. Some of these sysfs details needs to be
> > deprecated and removed. Applications should use /dev/rfkill
> actually.
>=20
> Maybe all of it should be in "obsolete"?

Maybe, maybe not. Some people hate /dev/rfkill because it means they
need to use a programming language (rather than shell scripts), and I
don't care enough to fight with them.

For all I care, it can be at the current status quo forever.

johannes

--=-/s4UwWFRmUZYtFD+85yu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLgqAiAAoJEODzc/N7+Qmal1cP/R3R9qticGG6Xg/KsElbzQR/
Hj/JhzvRyQo4cxbqkDxtEaC+GakNtBAxFs6hHNksHAyXl7UI7CMJ9PekinpUC07I
KoOmvJXfUYgsD2YuNNrKtMJP10QVAacRzUSDSfVNkVMRgGr/BvkoNWfUVyL2ymQp
CPlwFZm9lhbdSlKfYSl8Besja1kFpRqRgyo9Avx6MIMTadFFijd4D3kz3lMLcxge
nFRKvcZfCpQmT+hwIF7iG712lvzewdy1bU3Y7H2kDA2+c5Zrhe4WjHYf/x0/rLOJ
hOcrLuvdBXsHjmIe17TvxgHZnZp8Wttqrlm8Rl2fPud9Gr+tdI/XY062DFjaNvdu
au8a+UBmfJykv65T6R2mSoDl7PpPoZr8vtMI+kpvaOTLA2ELd9YtODBYSTBxHGrd
rR1wu+qwJHwQqDQO8UGHATHUfcATWfZyHmhTRSBStsxBkIBsl+DprqiHRLGMYvIk
KuxDekyIMMfBigLvp0k9/+MNWV9d1rhx2rUdivHTpfLEptaCQnyPr0ebdZPLWEmD
GjO3+kt5PE1TKrplJFQ5cSsA24v2Py9LLQaD0i015Myo7mwvtlp99Auujaapu2Ju
FUSYUJ5T16oQEJrVwzkjFmfI7VOlY8k4JTF/80AMmjo3tv1k9eV93ONJ27dYnWxW
QwpwRjDwI3ziHr24L4hs
=D9Zr
-----END PGP SIGNATURE-----

--=-/s4UwWFRmUZYtFD+85yu--

