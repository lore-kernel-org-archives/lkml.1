Return-Path: <linux-kernel-owner+w=401wt.eu-S1760531AbYHAXQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531AbYHAXQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbYHAXO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:14:56 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:40687 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbYHAXOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:14:55 -0400
Date: Fri, 1 Aug 2008 15:23:16 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: JosephChan@via.com.tw, geert@linux-m68k.org, akpm@linux-foundation.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 13/13] viafb: via_utility.c,
	via_utility.h, vt1636.c, vt1636.h
Message-ID: <20080801132316.GA2784@prithivi.gnumonks.org>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E78BE@exchtp03.taipei.via.com.tw> <20080630104407.6adf59ab@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20080630104407.6adf59ab@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2008 at 10:44:07AM +0100, Alan Cox wrote:

> I think at this point however the code is in a state where it would be
> more productive to merge it and then fix up the remaining smaller details
> than keep going round back to VIA to change it internally and return.

Well, I'm obviously not having any unbiased opinion on this anymore...
=2E.. but have a vital interest in getting this driver merged ;)

Joseph: Can you please give me an update about what the current state
of this driver merge is?  This message is the last one that I can find
ont this subject on linux-fbdev-devel, and it's already one month old.

Joseph: If there was any further work on this since your last
13-patch-posting in June, can you please provide me with the latest
driver patchset?  I'd be happy to help in cleaning this further up and
finally getting it mainline.

Thanks to everyone involved,
--=20
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFIkw5EXaXGVTD0i/8RAvZ+AKCkUzm1m+dsYSy2bVd0Eu+Lvi5rEgCfVmID
q8P8sHevDkvHFqf86PAUn+4=
=JwZW
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
