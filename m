Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYHFXod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYHFXod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 19:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYHFXnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 19:43:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56537 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbYHFXnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 19:43:17 -0400
Date: Thu, 7 Aug 2008 09:43:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mike.miller@hp.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Message-Id: <20080807094305.8d315d06.sfr@canb.auug.org.au>
In-Reply-To: <20080806103308.GM20055@kernel.dk>
References: <20080730211842.GF1758@roadking.ldev.net>
	<20080804095633.GA20055@kernel.dk>
	<20080805153012.0076396e.akpm@linux-foundation.org>
	<20080806130825.1567d882.sfr@canb.auug.org.au>
	<20080806103308.GM20055@kernel.dk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Aug_2008_09_43_05_+1000_0lucu8eP4BtesStq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Aug_2008_09_43_05_+1000_0lucu8eP4BtesStq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Wed, 6 Aug 2008 12:33:08 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> Thanks, but just keep pulling linux-next and I'll try and get them
> uptodate more frequently :-)

OK, will do.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Aug_2008_09_43_05_+1000_0lucu8eP4BtesStq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiaNwkACgkQjjKRsyhoI8y6cACcD7F+ShVnfRXbn/+vv9iaFtnj
DlUAoK7Y+1qhQNyru2wQ1fBHJ20JtF1I
=wDJQ
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Aug_2008_09_43_05_+1000_0lucu8eP4BtesStq--
