Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYJTHnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYJTHnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYJTHnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:43:37 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:58186 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbYJTHng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:43:36 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Max Kellermann <mk@cm4all.com>
Cc: Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org,
       Grant Coady <grant_lkml@dodo.com.au>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <20081020065149.GA11213@rabbit.intern.cm-ag>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <20081017143301.GA18522@poweredge.glommer>
	 <20081020065149.GA11213@rabbit.intern.cm-ag>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lCQfIZjGGdEU9nFVE8qv"
Date: Mon, 20 Oct 2008 08:43:23 +0100
Message-Id: <1224488603.23068.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=6OAc2UI1ETEA:10 a=Gm1qT94b7fUA:10 a=XoUB-yJnUyQWxTdTZ6oA:9 a=P7EKwNW0zaFCzbEVU6BR5Dqy2Q8A:4 a=LY0hPdMaydYA:10 a=5X-bIcuxxTv11fxI9xAA:9 a=QV9clJuH123qUD9a0zcInNr_Vr8A:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lCQfIZjGGdEU9nFVE8qv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 08:51 +0200, Max Kellermann wrote:
>=20
> On 2008/10/20 08:27, Ian Campbell <ijc@hellion.org.uk> wrote:
> > The issue I see still occurs well before those changesets. I have
> > seen it with v2.6.25 but v2.6.24 survived for 7 days without issue
> > (my threshold for a good kernel is 7 days, hence bisecting is a bit
> > slow...).
>=20
> Hello Ian,
>=20
> it seems we're hunting down different bugs after all.  Too bad, I
> hoped I could have solved your problem, too.

Thanks anyway, I'll just keep on bisecting ;-)

>   Our machine has been
> running well over the weekend with the patch I posted; with faulty
> kernels, the problem would occur after a few minutes.
>=20
--=20
Ian Campbell

BOFH excuse #400:

We are Microsoft.  What you are experiencing is not a problem; it is an und=
ocumented feature.

--=-lCQfIZjGGdEU9nFVE8qv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj8NpsACgkQM0+0qS9rzVn4LwCgov3L6+AN7Oig4IRaa/9/efBt
DmEAnR2mklOvtaF3yEWnM6PiEWbZfqDu
=aXN0
-----END PGP SIGNATURE-----

--=-lCQfIZjGGdEU9nFVE8qv--

