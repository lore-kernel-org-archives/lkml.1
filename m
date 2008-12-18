Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753429AbYLRLoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYLRLoq (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYLRLoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:44:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33319 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYLRLod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:44:33 -0500
Date: Thu, 18 Dec 2008 22:44:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, steved@redhat.com,
        rwheeler@redhat.com, bfields@fieldses.org, nfsv4@linux-nfs.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-Id: <20081218224418.804f10bc.sfr@canb.auug.org.au>
In-Reply-To: <8930.1229560221@redhat.com>
References: <8930.1229560221@redhat.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__18_Dec_2008_22_44_18_+1100_9Kz1EiBeOSAn1TCy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Dec_2008_22_44_18_+1100_9Kz1EiBeOSAn1TCy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, 18 Dec 2008 00:30:21 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> Can you try pulling the master branch of this tree:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-nfs-fsc=
ache.git
>=20
> into linux-next, please?

Added from today.

Usual spiel: all patches in that branch must have been
	posted to a relevant mailing list
	reviewed
	unit tested
	destined for the next merge window (or the current release)
*before* they are included.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__18_Dec_2008_22_44_18_+1100_9Kz1EiBeOSAn1TCy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklKN5IACgkQjjKRsyhoI8wvzgCfTY3tvRx4VCugiFKP1UHJ4FUk
MXsAn3f5wDrjTqTgf2v4oFpYgN3pL970
=TJMK
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Dec_2008_22_44_18_+1100_9Kz1EiBeOSAn1TCy--
