Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZK0EZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZK0EZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZK0EZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:25:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39317 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbZK0EZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:25:00 -0500
Date: Fri, 27 Nov 2009 15:24:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 0/17] [LogFS] New flash filesystem
Message-Id: <20091127152459.b427f4e5.sfr@canb.auug.org.au>
In-Reply-To: <20091126083614.GI10944@logfs.org>
References: <20091120181113.GA2159@logfs.org>
	<200911231318.39685.arnd@arndb.de>
	<20091125155510.GE10944@logfs.org>
	<20091126105103.4b2b4408.sfr@canb.auug.org.au>
	<20091126083614.GI10944@logfs.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Nov_2009_15_24_59_+1100_1bjiS9.ZWTkPl0y3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Nov_2009_15_24_59_+1100_1bjiS9.ZWTkPl0y3
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi J=C3=B6rn,

On Thu, 26 Nov 2009 09:36:15 +0100 J=C3=B6rn Engel <joern@logfs.org> wrote:
>
> Being of sound state of mind, I hereby request that you add

:-)

> git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git
> to linux-next.
>=20
> Something like that?  Or would you doubt my state of mind if I willing
> accept the risk of breaking others' compile and suffering the angry
> emails that inevitably follow?

Sometimes I question my own state of mind :-)

I have added the master branch of the above tree from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Fri__27_Nov_2009_15_24_59_+1100_1bjiS9.ZWTkPl0y3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksPVJsACgkQjjKRsyhoI8wE3QCeI5fTGMzx0gwKQOOHylhfDDSq
jWEAoI0Dvvay+hd4Dae1JBnF4hyzSYWd
=W0VY
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Nov_2009_15_24_59_+1100_1bjiS9.ZWTkPl0y3--
