Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbYEDH4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbYEDH4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYEDH4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:56:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40811 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbYEDH4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:56:31 -0400
Date: Sun, 4 May 2008 17:56:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: charter for -next
Message-Id: <20080504175612.07b0b0a0.sfr@canb.auug.org.au>
In-Reply-To: <481C3AA2.6020809@s5r6.in-berlin.de>
References: <481C3AA2.6020809@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__4_May_2008_17_56_12_+1000_NNAy0qpOKurYAEDO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__4_May_2008_17_56_12_+1000_NNAy0qpOKurYAEDO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

On Sat, 03 May 2008 12:12:50 +0200 Stefan Richter <stefanr@s5r6.in-berlin.d=
e> wrote:
>
> What should I ask myself before I commit something to the branch which=20
> Stephen pulls into -next?
>=20
>      Is this ready to be pulled by Linus right now if he had a merge
>      window open today?

This is what I want ideally.  So as stuff stabilises in subsystem trees,
it can be incorporated into linux-next and we can then figure out the
problems introduced by interactions with other subsystems.

>      Is it likely that I will let Linus pull this when he opens his next
>      merge window?  (Assuming I can roughly predict when this will be,
>      and what other work will likely be done until then, e.g. pending
>      reviewer feedback, or patches for related functionality which should
>      be bundled with the work in question...)

I suspect that this is what I got in some cases during the last
cycle :-) :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__4_May_2008_17_56_12_+1000_NNAy0qpOKurYAEDO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHWwoTgG2atn1QN8RAs88AJoD3GOnvWPbyJIvdt5sOcF5ogjfVQCdGljx
3mUcDgcMUVP+0+zREixD9wk=
=2D+q
-----END PGP SIGNATURE-----

--Signature=_Sun__4_May_2008_17_56_12_+1000_NNAy0qpOKurYAEDO--
