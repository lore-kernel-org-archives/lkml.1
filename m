Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbZJMCZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbZJMCZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbZJMCZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:25:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38612 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845AbZJMCZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:25:38 -0400
Date: Tue, 13 Oct 2009 13:24:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mmotm] synchro-test: add missing header file
Message-Id: <20091013132454.bbfb4a2e.sfr@canb.auug.org.au>
In-Reply-To: <20091012162015.9cc24569.akpm@linux-foundation.org>
References: <20091009161042.b301700c.randy.dunlap@oracle.com>
	<200910090830.n998Ubvv020464@imap1.linux-foundation.org>
	<23768.1255344678@redhat.com>
	<20091012162015.9cc24569.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Oct_2009_13_24_54_+1100_=h3XWCpK+sHWXe7U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Oct_2009_13_24_54_+1100_=h3XWCpK+sHWXe7U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 12 Oct 2009 16:20:15 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> kernel/synchro-test.c has mysteriously vanished from linux-next so I

That would be because it was never in linux-next :-)

See your patch mutex-subsystem-synchro-test-module.patch

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Oct_2009_13_24_54_+1100_=h3XWCpK+sHWXe7U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrT5PYACgkQjjKRsyhoI8w7QwCgq3H5E46q1rNffWFxSq3PMdX6
GLcAnj4YDFPrVSJYyGPDpa6GYLhJ2knl
=mLcg
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Oct_2009_13_24_54_+1100_=h3XWCpK+sHWXe7U--
