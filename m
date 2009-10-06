Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZJFS5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZJFS5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbZJFS5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:57:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957AbZJFS5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:57:02 -0400
Subject: Re: [patch] kbuild: Improve version string logic
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091006184911.GA833@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <20091006173508.GA4786@elte.hu> <1254854227.22426.37.camel@johannes.local>
	 <20091006184911.GA833@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-v4tcLI82nPGdGTA3ElqS"
Date: Tue, 06 Oct 2009 20:55:23 +0200
Message-Id: <1254855323.22426.39.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-v4tcLI82nPGdGTA3ElqS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-06 at 20:49 +0200, Ingo Molnar wrote:

> That said, i'm perfectly fine with just having the short version include=20
> the '+' sign (i.e. Linus's original patch), that was my original=20
> suggestion and that is already a big step forward.

However, that still breaks current make-kpkg iirc. I haven't used it in
quite some time, so I don't particularly care.

johannes

--=-v4tcLI82nPGdGTA3ElqS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKy5KXAAoJEODzc/N7+QmaBokP/RX/ocPwfbLDVXc8QMnZR6LU
676rakc1w0jqZM2RY9Y0LdlaxUKpV2FVi7qqUvKAvH8AeA0gcPUYDCA+vSPx7koJ
cIVHNs3wDWoiKHxO6FrNRQcPdxeEMvPeZNVeXBe6bwOdAyl4DLMlxEofWxtgaEPx
aM+w/oKH8PZVkRfJxjvYFgOIEHyrfHqe38nqfFbiPsn8NXquvAFwRCD7o9wjKwux
4rHVMjmLYEKu/G1Xh+w5ISMqOZYs42c3Ua/JwDsxk3KKGzfPG4eKjGUC9PapJT6D
gL14k6NYZtxCdKBzQ6t8Ie62PIrv8M5VaQ+fECR+wkIfOzEiKxDmWMhdngJ3p3h9
JpU1m8xhvALTNQqXIcEcj/ujrqSBIrCqbMvYUTijdPf3413jJGdvBvUg6qDjTvjo
gUmeYKbxXlkAWYBGY0ymJ6c5z5v1l2gF1h/z5EDmwGkEdKhyW5aSlZQbc8lz3FS0
Lp8je0sWTmooc8+N6Si0/+FavvsBh1j6put+XNrUPnAPMpCbn4owBNLQls8MmAez
NwiBxR4eq5gkjpC/n6HZghiqsug6pYBSdiAuKIgHBvLzhY2AxHYgzSCgFG4FTn9g
IDCeXA1WxVXIc9vJIPnHLRxtFbshgq+3CQRMwHgsBJ9iw6yg+ezvjVq4tfyBB1Jf
06UsaRgiIFeNZj26Nzar
=g3Ql
-----END PGP SIGNATURE-----

--=-v4tcLI82nPGdGTA3ElqS--

