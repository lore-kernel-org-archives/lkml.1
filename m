Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbZFJOUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbZFJOUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbZFJOUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:20:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36135 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621AbZFJOUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:20:04 -0400
Date: Thu, 11 Jun 2009 00:19:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] headers_check fix patches 20090610
Message-Id: <20090611001957.61b5530b.sfr@canb.auug.org.au>
In-Reply-To: <1244640630.20890.22.camel@ht.satnam>
References: <1244640630.20890.22.camel@ht.satnam>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Jun_2009_00_19_57_+1000_XeJdwgQlO9QkDWq2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jun_2009_00_19_57_+1000_XeJdwgQlO9QkDWq2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaswinder,

On Wed, 10 Jun 2009 19:00:30 +0530 Jaswinder Singh Rajput <jaswinder@kernel=
.org> wrote:
>
> The following changes since commit e271e1343a94e081723cb4180af3fdb5fecc1a=
49:
>   Ingo Molnar (1):
>         Merge branch 'x86/mce4'
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-top.g=
it master
>=20
> Jaswinder Singh Rajput (3):
>       headers_check fix: m68k, swab.h
>       headers_check fix: mn10300, ptrace.h
>       headers_check fix: mn10300, setup.h
>=20
>  arch/m68k/include/asm/swab.h      |    2 +-
>  arch/mn10300/include/asm/ptrace.h |    5 ++---
>  arch/mn10300/include/asm/setup.h  |    3 ++-
>  3 files changed, 5 insertions(+), 5 deletions(-)

Is there some reason that these fixes are not just sent to the appropriate
maintainers?  That way we would avoid unnecessary conflicts cropping up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Jun_2009_00_19_57_+1000_XeJdwgQlO9QkDWq2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovwQ0ACgkQjjKRsyhoI8z7agCbBlrqBQ7yXW+SriLIrHblrs/U
F9EAn0yuZizH6Kt4csoN2uU5Z3CFvIPx
=1CrF
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jun_2009_00_19_57_+1000_XeJdwgQlO9QkDWq2--
