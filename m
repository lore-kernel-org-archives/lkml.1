Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZFSCAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZFSCAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZFSCAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:00:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49361 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZFSCAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:00:33 -0400
Date: Fri, 19 Jun 2009 12:00:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Sager <sager@netapp.com>
Subject: Re: linux-next: nfs tree build warning
Message-Id: <20090619120030.1e4ff961.sfr@canb.auug.org.au>
In-Reply-To: <1245373752.8756.59.camel@heimdal.trondhjem.org>
References: <20090619105022.4dc10679.sfr@canb.auug.org.au>
	<1245373752.8756.59.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Jun_2009_12_00_30_+1000_mLYZ_popJSu.V1ev"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Jun_2009_12_00_30_+1000_mLYZ_popJSu.V1ev
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

On Thu, 18 Jun 2009 18:09:12 -0700 Trond Myklebust <trond.myklebust@fys.uio=
.no> wrote:
>
> That's my fault: it was due to inattention during the merge of the
> nfsv41 tree with the mainline NFS changes. I'll fix...

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Jun_2009_12_00_30_+1000_mLYZ_popJSu.V1ev
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko68T4ACgkQjjKRsyhoI8yTXACglEv5qxbd+SKyCwCuHMinjVdo
EvUAoJIR5U4p2NSpUFyAooxxcQaJsM9w
=oLRb
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Jun_2009_12_00_30_+1000_mLYZ_popJSu.V1ev--
