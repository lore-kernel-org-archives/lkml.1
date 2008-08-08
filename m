Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYHHAXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYHHAXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYHHAXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:23:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37450 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbYHHAXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:23:35 -0400
Date: Fri, 8 Aug 2008 10:23:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       morgan@kernel.org, viro@ftp.linux.org.uk, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/24] Introduce credentials [ver #7]
Message-Id: <20080808102317.4d2a37f0.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LRH.1.10.0808072156240.18676@tundra.namei.org>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
	<alpine.LRH.1.10.0808072156240.18676@tundra.namei.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Aug_2008_10_23_17_+1000_L/oFL=eva8r.Lmz7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Aug_2008_10_23_17_+1000_L/oFL=eva8r.Lmz7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 7 Aug 2008 22:03:57 +1000 (EST) James Morris <jmorris@namei.org> wr=
ote:
>
> On Wed, 6 Aug 2008, David Howells wrote:
>=20
> > I've brought my patchset up to date with regards the recent merge melee=
 and
> > built the patches on top of the next branch of James's security testing=
 tree as
> > per his request.
>=20
> These patches are now in=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.=
6#next-creds
>=20
> This is the 'next' branch + the credentials patches.
>=20
> Stephen, could you add 'next-creds' to linux-next?

OK, I have added it from today with you and David as contacts.  It is
right at the end of the merge, so it will go away if it is too painful (I
don't expect it to be, just letting you know).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Aug_2008_10_23_17_+1000_L/oFL=eva8r.Lmz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkibkfUACgkQjjKRsyhoI8zZ1QCfWOgCIFGbkmPLNpVVsMzaqcs5
5tMAnRbfxYnQpsQIBThh5lLR6nu5kLr1
=afc1
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Aug_2008_10_23_17_+1000_L/oFL=eva8r.Lmz7--
