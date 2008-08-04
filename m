Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYHDQ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYHDQ7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYHDQ7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:59:03 -0400
Received: from home.keithp.com ([63.227.221.253]:4603 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbYHDQ7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:59:01 -0400
Subject: Re: files/process scaling problem? (was: [PATCH] Export
	shmem_file_setup and shmem_getpage for DRM-GEM)
From: Keith Packard <keithp@keithp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: keithp@keithp.com, Arjan van de Ven <arjan@infradead.org>,
       Ingo Oeser <ioe-lkml@rameria.de>, John Stoffel <john@stoffel.org>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080804151146.71d9fcce@lxorguk.ukuu.org.uk>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <18581.43362.460694.60862@stoffel.org>
	 <1217785943.23437.330.camel@koto.keithp.com>
	 <200808040135.32563.ioe-lkml@rameria.de>
	 <1217809152.23437.401.camel@koto.keithp.com>
	 <20080804091930.164f31c3@lxorguk.ukuu.org.uk>
	 <20080804065101.6f70725a@infradead.org>
	 <20080804151146.71d9fcce@lxorguk.ukuu.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-n7e7Yq3aGhJqU5yuMlLy"
Date: Mon, 04 Aug 2008 09:58:54 -0700
Message-Id: <1217869134.24714.70.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-n7e7Yq3aGhJqU5yuMlLy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 15:11 +0100, Alan Cox wrote:

> X libraries provide the event loop so that isn't really as complex as it
> seems.

Uh, no, X doesn't. Gtk+ and Qt provide event loops that applications may
use, but still many choose to roll their own.

>  Shuffling the handles around for the benefit of the odd legacy app
> isn't something I'd disagree with but DRI and X in the general case can
> determine the event loop system used by the application.

Yeah, it would be nice if we could just fix all of the existing
applications. When you get that working, let me know and I'll take you
for a ride in my flying car.

--=20
keith.packard@intel.com

--=-n7e7Yq3aGhJqU5yuMlLy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIlzVOQp8BWwlsTdMRAljLAKCiqvtS9qUtOmmKxMyQte9i8EqOxACgoH6Z
P/MJCYGMmpkTnOeFLgwQx+o=
=eags
-----END PGP SIGNATURE-----

--=-n7e7Yq3aGhJqU5yuMlLy--

