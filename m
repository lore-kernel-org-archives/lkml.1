Return-Path: <linux-kernel-owner+w=401wt.eu-S1765415AbZLQVcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765415AbZLQVcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765405AbZLQVcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:32:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45813 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765404AbZLQVcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:32:19 -0500
Date: Fri, 18 Dec 2009 08:32:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: fsnotify tree build failure
Message-Id: <20091218083212.3088eb07.sfr@canb.auug.org.au>
In-Reply-To: <1261054623.2788.146.camel@localhost>
References: <20091217144506.d73902de.sfr@canb.auug.org.au>
	<1261054623.2788.146.camel@localhost>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Dec_2009_08_32_12_+1100_BWPuGSc9JvfAK=IM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Dec_2009_08_32_12_+1100_BWPuGSc9JvfAK=IM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, 17 Dec 2009 07:57:03 -0500 Eric Paris <eparis@redhat.com> wrote:
>
> On Thu, 2009-12-17 at 14:45 +1100, Stephen Rothwell wrote:
> > I applied the following merge fix (I *think* it is correct but may easi=
ly
> > require something more - Al?) for today (and can carry it for a while):
>=20
> Actually it requires less!  All of the IMA stuff needs to be dropped in
> light of my/Al's IMA rework.  I'll take care of it today.

Even better, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__18_Dec_2009_08_32_12_+1100_BWPuGSc9JvfAK=IM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksqo1wACgkQjjKRsyhoI8wmegCfTXS7KVsq0Y96a3DU/A5WqktO
Ld4AmwdtbkToq4m4y/9U6R1Yz2Pv0Ydu
=ns6g
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Dec_2009_08_32_12_+1100_BWPuGSc9JvfAK=IM--
