Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYIRRxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYIRRxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYIRRxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:53:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60785 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbYIRRxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:53:05 -0400
Date: Fri, 19 Sep 2008 03:52:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-09-13-03-09 uploaded
Message-Id: <20080919035248.d3187001.sfr@canb.auug.org.au>
In-Reply-To: <20080918022353.dca4b5c3.akpm@linux-foundation.org>
References: <200809131011.m8DABTON031878@imap1.linux-foundation.org>
	<20080918150115.1aa45123.kamezawa.hiroyu@jp.fujitsu.com>
	<20080917232648.5b991958.akpm@linux-foundation.org>
	<1221727868.6892.66.camel@odin>
	<20080918022353.dca4b5c3.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Sep_2008_03_52_48_+1000_TVNsCTOhzs/I9nO="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Sep_2008_03_52_48_+1000_TVNsCTOhzs/I9nO=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Liam,

On Thu, 18 Sep 2008 02:23:53 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> > Can I just confirm the repository & branch you are pulling as I've
> > recently left Wolfson and now work for myself (I will no longer have
> > guaranteed access to the Wolfson git repositories). I've also moved
> > regulator development over to kernel.org:-
> >=20
> > git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git #dev
> >=20
>=20
> Please send that off to Stephen for linux-next inclusion.

I have this:

Liam Girdwood <lg@opensource.wolfsonmicro.com>
voltage git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git#r=
eg-for-linus

in the linux-next list already.  Do I assume that some changes are needed
(email and branch)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Sep_2008_03_52_48_+1000_TVNsCTOhzs/I9nO=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjSlXAACgkQjjKRsyhoI8ynqQCgkfw2DZYk4VjB641DCXP3CjN7
26YAniCNu5Jg1gxv7wsSX/sE9fdTIsMl
=0vww
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Sep_2008_03_52_48_+1000_TVNsCTOhzs/I9nO=--
