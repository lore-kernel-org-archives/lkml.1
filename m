Return-Path: <linux-kernel-owner+w=401wt.eu-S933136Ab0AFXvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab0AFXvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044Ab0AFXvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:51:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43685 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab0AFXvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:51:36 -0500
Date: Thu, 7 Jan 2010 10:51:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jeff Layton <jlayton@redhat.com>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2] sunrpc: fix build-time warning
Message-Id: <20100107105130.dfae78e3.sfr@canb.auug.org.au>
In-Reply-To: <1262819420.4251.171.camel@localhost>
References: <1262226195-27733-1-git-send-email-jlayton@redhat.com>
	<20091231091815.a1ea7e51.rdunlap@xenotime.net>
	<20091231205454.0f84f091@tupile.poochiereds.net>
	<20100101182514.cb1f49ef.randy.dunlap@oracle.com>
	<1262819420.4251.171.camel@localhost>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Jan_2010_10_51_30_+1100_RdOm4p3r28qPxABR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jan_2010_10_51_30_+1100_RdOm4p3r28qPxABR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

On Wed, 06 Jan 2010 18:10:20 -0500 Trond Myklebust <trond.myklebust@fys.uio=
.no> wrote:
>
> Sorry for the delay. This patch has been applied today, and should
> therefore appear in the linux-next tree tomorrow...

Actually today - since I am following the normal Australian practice of
being slack and starting work late in January :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Jan_2010_10_51_30_+1100_RdOm4p3r28qPxABR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktFIgIACgkQjjKRsyhoI8xIIwCfdLXC2Jpw1WYEBFzZeDnJKRht
A3AAni3fIEMHyw37k9Hhh6RuCub4GgOT
=AW0I
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jan_2010_10_51_30_+1100_RdOm4p3r28qPxABR--
