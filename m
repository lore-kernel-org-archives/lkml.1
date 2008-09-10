Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYIJMyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYIJMyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYIJMye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:54:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:42878 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYIJMyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:54:33 -0400
Date: Wed, 10 Sep 2008 15:55:04 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <caulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] include <linux/types.h> into linux/dlm_plock.h for
	__u* typedef
Message-ID: <20080910125503.GG3757@localhost.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <1221045726-5674-2-git-send-email-kirill@shutemov.name> <20080910121450.GA3468@x200.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HB4mHL4PVvkpZAgW"
Content-Disposition: inline
In-Reply-To: <20080910121450.GA3468@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HB4mHL4PVvkpZAgW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2008 at 04:14:50PM +0400, Alexey Dobriyan wrote:
> On Wed, Sep 10, 2008 at 02:22:04PM +0300, Kirill A. Shutemov wrote:
> > --- a/include/linux/dlm_plock.h
> > +++ b/include/linux/dlm_plock.h
>=20
> > +#include <linux/types.h>
>=20
> I'd say that unless you can demonstrate compilation breakage, these will
> only slow down compilation.

Do you think that minor slow down is worse than dependence on the order of
inclusion?

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--HB4mHL4PVvkpZAgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkjHw6cACgkQbWYnhzC5v6obZQCaAp08FcYM+0gXsFflOoXif/fF
CuIAlAvOScT04s++JO5M1PyvNmgJlog=
=1JCG
-----END PGP SIGNATURE-----

--HB4mHL4PVvkpZAgW--
