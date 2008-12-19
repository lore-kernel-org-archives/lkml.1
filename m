Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYLSAGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYLSAGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYLSAFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:05:55 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52573 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYLSAFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:05:54 -0500
Date: Fri, 19 Dec 2008 11:05:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: dhowells@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bernd Schubert <bernd.schubert@fastmail.fm>, nfsv4@linux-nfs.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
       linux-next@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-Id: <20081219110539.7e7e230c.sfr@canb.auug.org.au>
In-Reply-To: <20081218152616.a24c013f.akpm@linux-foundation.org>
References: <8930.1229560221@redhat.com>
	<20081218142420.GA16728@infradead.org>
	<20081218123601.11810b7f.akpm@linux-foundation.org>
	<200812190007.34581.bernd.schubert@fastmail.fm>
	<20081218152616.a24c013f.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Dec_2008_11_05_39_+1100_P_kj1envGlQP_0Q."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Dec_2008_11_05_39_+1100_P_kj1envGlQP_0Q.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Given the ongoing discussions around FS-Cache, I have removed it from
linux-next.  Please ask me to include it again (if sensible) once some
decision has been reached about its future.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Dec_2008_11_05_39_+1100_P_kj1envGlQP_0Q.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklK5VMACgkQjjKRsyhoI8xJzQCfb1a9LSsjK5b8VLmIaRS84Kx4
/uwAn3jU/qcYkee0c+nre5UpCkBs5BgK
=ccN7
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Dec_2008_11_05_39_+1100_P_kj1envGlQP_0Q.--
