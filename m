Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbZJMLxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbZJMLxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759566AbZJMLxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:53:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58041 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759551AbZJMLxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:53:45 -0400
Date: Tue, 13 Oct 2009 22:53:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: manual merge of the i7core_edac tree with Linus'
 tree
Message-Id: <20091013225304.211dc64e.sfr@canb.auug.org.au>
In-Reply-To: <1209036982.100421255434636304.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
References: <20091012142328.710881fe.sfr@canb.auug.org.au>
	<1209036982.100421255434636304.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Oct_2009_22_53_04_+1100_Fr+AjoaMiwNyZb+2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Oct_2009_22_53_04_+1100_Fr+AjoaMiwNyZb+2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Tue, 13 Oct 2009 07:50:36 -0400 (EDT) Mauro Carvalho Chehab <mchehab@red=
hat.com> wrote:
>
> Thanks for letting me know. I've rebased it fixing the merge conflict. Fo=
r now,
> I just removed the call to edac_mce_parse() for Uncorrected Errors, since=
 I'll
> eventually replace that part of the code with something better.
>=20
> You should now be able to merge it without merging conflicts.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Oct_2009_22_53_04_+1100_Fr+AjoaMiwNyZb+2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrUaiAACgkQjjKRsyhoI8ycIQCgnvYj6diFZAKYRQt1NvUuYbdr
EnoAoIOnW+cZWH1+XrR/qAdmJseQDAo9
=R4/V
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Oct_2009_22_53_04_+1100_Fr+AjoaMiwNyZb+2--
