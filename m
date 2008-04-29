Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbYD2XsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbYD2XsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 19:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYD2Xrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 19:47:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54957 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbYD2Xru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 19:47:50 -0400
Date: Wed, 30 Apr 2008 09:47:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: PCI tree info
Message-Id: <20080430094742.589add5a.sfr@canb.auug.org.au>
In-Reply-To: <200804291100.08622.jbarnes@virtuousgeek.org>
References: <200804291100.08622.jbarnes@virtuousgeek.org>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Apr_2008_09_47_42_+1000_+78W4cq8gQEjrlzC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Apr_2008_09_47_42_+1000_+78W4cq8gQEjrlzC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Tue, 29 Apr 2008 11:00:08 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:
>
> The PCI tree now lives in git: =20
> git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.  There are=
 a=20
> few branches:
>   for-linus - stuff headed to Linus in the next pull request
>   linux-next - patches targetted at the following release

I have added both these to linux-next as "pci-current" and "pci"
respectively.  These have just you as the contact - let me know if you
want someone else as well (or even a mailing list).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Apr_2008_09_47_42_+1000_+78W4cq8gQEjrlzC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIF7OiTgG2atn1QN8RAvmZAJ4rvw6iCd4iLVMTRe+TnIqTm2HaLwCdG2v3
BJDBJ/OqFg5J1QfpLTWDHEU=
=VVIR
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Apr_2008_09_47_42_+1000_+78W4cq8gQEjrlzC--
