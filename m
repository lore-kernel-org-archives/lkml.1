Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZG3XZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZG3XZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZG3XZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:25:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37166 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZG3XZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:25:44 -0400
Date: Fri, 31 Jul 2009 09:25:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: OProfile for linux-next
Message-Id: <20090731092537.239995b5.sfr@canb.auug.org.au>
In-Reply-To: <20090730120738.GA24694@erda.amd.com>
References: <20090730120738.GA24694@erda.amd.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__31_Jul_2009_09_25_37_+1000_wlQNhOvGg_4pFV=Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__31_Jul_2009_09_25_37_+1000_wlQNhOvGg_4pFV=Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robert,

On Thu, 30 Jul 2009 14:07:38 +0200 Robert Richter <robert.richter@amd.com> =
wrote:
>
> please add following tree to linux-next:
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next
>=20
> This is the oprofile master branch containing all changes for the next
> merge window.

Added from today.

> The general way of sending oprofile to linux-next is via tip. So, this
> will be a temporary solution until Ingo will be back.

I added it after the tip tree, so if it hangs around for a few days after
Ingo has integrated it, it should not be a problem.

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
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__31_Jul_2009_09_25_37_+1000_wlQNhOvGg_4pFV=Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpyK/EACgkQjjKRsyhoI8yq5gCdG1+tcx1h73+pSdMs/DCJNuME
vvEAn2nZzjQSwKy+IeO0joj7ihdyzfjQ
=A0bI
-----END PGP SIGNATURE-----

--Signature=_Fri__31_Jul_2009_09_25_37_+1000_wlQNhOvGg_4pFV=Z--
