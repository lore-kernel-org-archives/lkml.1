Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbZFNXIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbZFNXIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZFNXIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:08:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44128 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbZFNXIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:08:36 -0400
Date: Mon, 15 Jun 2009 09:08:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: kbuild tree build warning
Message-Id: <20090615090836.47db3c6b.sfr@canb.auug.org.au>
In-Reply-To: <20090615090655.9157bcc1.sfr@canb.auug.org.au>
References: <20090610115255.035da856.sfr@canb.auug.org.au>
	<20090610064723.GA25493@uranus.ravnborg.org>
	<20090615090655.9157bcc1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Jun_2009_09_08_36_+1000_IR6Jy88oQ2O2T5tQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jun_2009_09_08_36_+1000_IR6Jy88oQ2O2T5tQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Mon, 15 Jun 2009 09:06:55 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Then why didn't it make it into the version that just got into Linus'
> tree?  Also the other I mentioned:
>=20
> include/asm-generic/vmlinux.lds.h:695:1: warning: "/*" within comment

Sorry, I see you did a later commit to fix those, even though they
weren't mentioned in the commit message ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Jun_2009_09_08_36_+1000_IR6Jy88oQ2O2T5tQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko1gvQACgkQjjKRsyhoI8yF4ACaAw7aUMeuhYy/3PhUGLfrKvAq
8Z4An35SYq0s6UorOaV9djXHML5notv0
=I4bu
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jun_2009_09_08_36_+1000_IR6Jy88oQ2O2T5tQ--
