Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZHJJpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZHJJpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZHJJpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:45:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58825 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZHJJpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:45:34 -0400
Date: Mon, 10 Aug 2009 19:45:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: hwpoison merge for linux-next / 2.6.32
Message-Id: <20090810194528.a3bc0cbc.sfr@canb.auug.org.au>
In-Reply-To: <20090807084902.GA14309@basil.fritz.box>
References: <20090807084902.GA14309@basil.fritz.box>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Aug_2009_19_45_28_+1000_5pnXtiIAC5q4PARo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Aug_2009_19_45_28_+1000_5pnXtiIAC5q4PARo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Fri, 7 Aug 2009 10:49:02 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>
> Could you please pull git://git.kernel.org/pub/scm/linux/kernel/git/ak/li=
nux-mce-2.6.git hwpoison
> into linux-next?
>=20
> hwpoison is the VM part of extended memory error handling.
>=20
> This tree has been extensively reviewed now and people seem to be happy n=
ow and is=20
> imho ready for merge.
>=20
> Andrew also indicated earlier he would merge it for .32.

OK, I have added this today.

What I tell everyone: all patches/commits in the tree/series must
have been:

	posted to a relevant mailing list
	reviewed
	unit tested
	destined for the next merge window (or the current release)

*before* they are included.  The linux-next tree is for integration
testing and to lower the impact of conflicts between subsystems in the
next merge window.

Basically, this should be just what you would send to Linus or in this
case, Ingo, (or ask him to fetch).  It is allowed to be rebased if you
deem it necessary.

> How do you want to handle it. Will you take it and send or should I send =
direct=20
> pull requests to Linus during the merge window?

Andrew, If you have other plans, just yell.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Aug_2009_19_45_28_+1000_5pnXtiIAC5q4PARo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp/7DgACgkQjjKRsyhoI8w2hACgv2BU+2RfqqdE56kpz+Bo7/85
G+AAn1L3j1lsRfzZbazbUfHU06PJtbjA
=btoT
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Aug_2009_19_45_28_+1000_5pnXtiIAC5q4PARo--
