Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZGAEcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZGAEcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZGAEb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:31:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48218 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZGAEb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:31:57 -0400
Date: Wed, 1 Jul 2009 14:31:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] perf top: Move skip symbols to an array
Message-Id: <20090701143154.29cc8e1d.sfr@canb.auug.org.au>
In-Reply-To: <20090630230140.904782938@samba.org>
References: <20090630230043.464194676@samba.org>
	<20090630230140.904782938@samba.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jul_2009_14_31_54_+1000_j0bk0sceNCot8EIx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jul_2009_14_31_54_+1000_j0bk0sceNCot8EIx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Anton,

On Wed, 01 Jul 2009 09:00:46 +1000 Anton Blanchard <anton@samba.org> wrote:
>
> +/* Tag samples to be skipped. */
> +char *skip_symbols[] =3D {

"static const" ?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Jul_2009_14_31_54_+1000_j0bk0sceNCot8EIx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpK5roACgkQjjKRsyhoI8z7ugCglRquh+YAGbzCY1zwFbMWSjRx
yn4An0oAScAguQwQbg3Jk+/tcct/gUoO
=bMGX
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jul_2009_14_31_54_+1000_j0bk0sceNCot8EIx--
