Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZINWgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZINWgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbZINWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:36:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40491 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457AbZINWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:36:07 -0400
Date: Tue, 15 Sep 2009 08:36:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree
 build warning)
Message-Id: <20090915083601.41bf16e1.sfr@canb.auug.org.au>
In-Reply-To: <1252936201.2964.59.camel@localhost.localdomain>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au>
	<1249403089.4634.139.camel@localhost.localdomain>
	<20090912165300.9d257283.sfr@canb.auug.org.au>
	<20090912073906.GA3972@elte.hu>
	<1252936201.2964.59.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Sep_2009_08_36_01_+1000_icbpFa729/f1lXND"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Sep_2009_08_36_01_+1000_icbpFa729/f1lXND
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Mon, 14 Sep 2009 09:50:01 -0400 Steven Rostedt <srostedt@redhat.com> wro=
te:
>
> On Sat, 2009-09-12 at 09:39 +0200, Ingo Molnar wrote:
> > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > > Now that this is in Linus' tree, can we have a fix for the waning,=20
> > > please?
> >=20
> > The first warning got fixed 1.5 months ago - the second one at line=20
> > 797 is still there but harmless - you can ignore it for now, it will=20
> > be fixed.
>=20
> The first warning never got fixed. The typecast was placed in the wrong
> spot (my fault). I sent another patch that fixes both warnings.

Thanks for that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Sep_2009_08_36_01_+1000_icbpFa729/f1lXND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkquxVEACgkQjjKRsyhoI8wHFwCaAqaPkFm9aq3oOUc1i0OH52Vy
29kAn2isI+Mtp/4iVipP4u0JYDu8rThJ
=gFS3
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Sep_2009_08_36_01_+1000_icbpFa729/f1lXND--
