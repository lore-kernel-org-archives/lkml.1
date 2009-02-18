Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZBRPTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZBRPTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZBRPTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:19:07 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:55675 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZBRPTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:19:06 -0500
Date: Wed, 18 Feb 2009 17:22:52 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [RESEND] binfmt_script: rewrite using
	parse_shell_args()
Message-ID: <20090218152252.GB5270@epbyminw8406h.minsk.epam.com>
References: <1234970162-10694-1-git-send-email-kirill@shutemov.name> <1234970162-10694-2-git-send-email-kirill@shutemov.name> <20090218151616.GC15195@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <20090218151616.GC15195@srcf.ucam.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2009 at 03:16:16PM +0000, Matthew Garrett wrote:
> On Wed, Feb 18, 2009 at 05:16:01PM +0200, Kirill A. Shutemov wrote:
> > parse_shell_args() allows to use more than one argument in shebang.
>=20
> As mentioned before, this breaks userspace ABI.

Do you have real world example of breakage?

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.org/

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmcJ8wACgkQbWYnhzC5v6rZGwCfaZpo9SYlnHyQpyX7S+lYD/1r
qRoAn1tUBKAenALRUaaEPtBwEK1NQ+5S
=i3Zs
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
