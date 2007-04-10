Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXDJNox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXDJNox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 09:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXDJNox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 09:44:53 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:48418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbXDJNow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 09:44:52 -0400
Subject: Re: [PATCH] Build break on ppc64 for 2.6.21-rc6-mm1
From: Johannes Berg <johannes@sipsolutions.net>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
In-Reply-To: <200704101820.47509.srinivasa@in.ibm.com>
References: <200704101820.47509.srinivasa@in.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tjSVKLJg46V0RiastZOb"
Date: Tue, 10 Apr 2007 15:45:21 +0200
Message-Id: <1176212721.8459.97.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tjSVKLJg46V0RiastZOb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-04-10 at 18:20 +0530, Srinivasa Ds wrote:

> Below patch fixes this problem. please let me know comments on this.

+#include <linux/sysdev.h>


Yeah, I heard about that change but didn't have a chance to check it out
yet. Patch looks good to me, of course.

johannes

--=-tjSVKLJg46V0RiastZOb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGG5Tw/ETPhpq3jKURAsexAJ4ohDHy4XFT9+4io0tp3RipW7QTqQCeLrZ1
YNGdAvf7ly6rqunH1FvcmAI=
=7mfY
-----END PGP SIGNATURE-----

--=-tjSVKLJg46V0RiastZOb--

