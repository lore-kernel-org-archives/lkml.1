Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYHCPC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYHCPC4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbYHCPCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:02:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40641 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbYHCPCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:02:46 -0400
Date: Mon, 4 Aug 2008 01:02:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, ppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rdreier@cisco.com>,
       general@lists.openfabrics.org
Subject: Re: [PATCH v2] powerpc: move include files to
 arch/powerpc/include/asm
Message-Id: <20080804010238.a493e1c0.sfr@canb.auug.org.au>
In-Reply-To: <A5259752-468C-4CBA-BEF3-4E088ED1A5B9@kernel.crashing.org>
References: <20080801152030.ff10b6b2.sfr@canb.auug.org.au>
	<A5259752-468C-4CBA-BEF3-4E088ED1A5B9@kernel.crashing.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Aug_2008_01_02_38_+1000_UEqVS_pRBb.n0ozB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Aug_2008_01_02_38_+1000_UEqVS_pRBb.n0ozB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Aug 2008 09:58:14 -0500 Kumar Gala <galak@kernel.crashing.org> wr=
ote:
>
> Paul, what's the plan for this change?  If this is something that will =20
> go in so can we get a tree with it so we can base other patches on it =20
> (like the PPC_MERGE cleanup)?

It looks like Linus is happy to take these patches, so if Paul is game he
could just shove it in powerpc-{next,master,merge} and ask Linus to pull
it.  The sooner the better in that case.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Aug_2008_01_02_38_+1000_UEqVS_pRBb.n0ozB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiVyI4ACgkQjjKRsyhoI8ypigCgs1ZlTYhitZ49N+k40abxXlV/
UqIAoK6Vlu4nVDo+6dXUim3w2XUk4EsC
=rBK2
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Aug_2008_01_02_38_+1000_UEqVS_pRBb.n0ozB--
