Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYJGLVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYJGLVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYJGLUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:20:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:55806 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbYJGLUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:20:54 -0400
Date: Tue, 7 Oct 2008 14:21:58 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007112157.GA5126@localhost.localdomain>
References: <20081006132651.GG3180@one.firstfloor.org> <1223303879-5555-1-git-send-email-kirill@shutemov.name> <20081007195837.5A6B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081007112119.GG20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20081007112119.GG20740@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2008 at 01:21:19PM +0200, Andi Kleen wrote:
> > Honestly, I don't like that qemu specific feature insert into shmem cor=
e.
>=20
> I wouldn't say it's a qemu specific interface.  While qemu would=20
> be the first user I would expect more in the future. It's a pretty
> obvious extension. In fact it nearly should be default, if the
> risk of breaking old applications wasn't too high.

It's bad idea. It will break POSIX compatible.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjrRlUACgkQbWYnhzC5v6o9ZQCfdXw0/6+rOfTVNOdznzH0YGg6
2j0An1LTSY9Db6LJchJe2avOxbzuFcSH
=BigC
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
