Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbZCaDBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbZCaDBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 23:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbZCaDBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 23:01:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43195 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760984AbZCaDBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 23:01:34 -0400
Date: Tue, 31 Mar 2009 14:01:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, avishay@gmail.com, jeff@garzik.org,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, zbr@ioremap.net,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, linux-next@vger.kernel.org
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
Message-Id: <20090331140124.a21da743.sfr@canb.auug.org.au>
In-Reply-To: <20090330142200.af4b497c.akpm@linux-foundation.org>
References: <49C1331D.1080805@panasas.com>
	<20090330142200.af4b497c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__31_Mar_2009_14_01_24_+1100_O+4Ko2zyoDDMMU3N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Mar_2009_14_01_24_+1100_O+4Ko2zyoDDMMU3N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Mar 2009 14:22:00 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> > This patchset is also available on:
> >   git-clone git://git.open-osd.org/linux-open-osd.git linux-next
> > or on the web at:
> >   http://git.open-osd.org/gitweb.cgi?p=3Dlinux-open-osd.git;a=3Dshortlo=
g;h=3Drefs/heads/linux-next
>=20
> Well I could merge them, but given that you have a git tree, a more
> convenient path would be for us to include your tree in linux-next and
> then you ask Linus to pull it directly when the time comes.

$ git cat-file -p next-20090330:Next/Trees | grep osd
osd		git	git://git.open-osd.org/linux-open-osd.git#linux-next

i.e. its in there.  Those particular patches have been in linux-next
since next-20090326 and presumably have been built by the
all{yes,mod}config builds I do.

> I'm unsure when that time will come.  Who has reviewed this work and
> what was the result?

That is a good question.  The other is "Is this destined for 2.6.30?"

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__31_Mar_2009_14_01_24_+1100_O+4Ko2zyoDDMMU3N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknRh4QACgkQjjKRsyhoI8xDgwCglNFmLN5P9morMjPPbqBcpfRa
ymgAoLGhL7eNAm+DTUDYOnqOsSA2l2hz
=PKgw
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Mar_2009_14_01_24_+1100_O+4Ko2zyoDDMMU3N--
