Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896Ab0ATHAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0ATHAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181Ab0ATHAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:00:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59756 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab0ATHAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:00:09 -0500
Date: Wed, 20 Jan 2010 17:59:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-Id: <20100120175959.59daa481.sfr@canb.auug.org.au>
In-Reply-To: <20100120062834.GB12165@elte.hu>
References: <20100119211646.GF16096@redhat.com>
	<20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
	<20100120054950.GB27108@elte.hu>
	<20100120061551.GB6588@in.ibm.com>
	<20100120062834.GB12165@elte.hu>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jan_2010_17_59_59_+1100_D3wSZ4FjdL/zm5He"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jan_2010_17_59_59_+1100_D3wSZ4FjdL/zm5He
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frank,

On Wed, 20 Jan 2010 07:28:34 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> Including experimental code that is RFC and which is not certain to go=20
> upstream is certainly not the purpose of linux-next though.

Ingo is correct in what he says here.  See the boilerplate:

"     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch)."

I will remove this tree from linux-next tomorrow and wait until it is
more ready for mainline inclusion.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jan_2010_17_59_59_+1100_D3wSZ4FjdL/zm5He
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktWqe8ACgkQjjKRsyhoI8waqwCeKAuM57L412X0UK/aNa0vPR3G
P6UAoLDTK3LHo3U3OKwer2D1r/Icnevb
=Htge
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jan_2010_17_59_59_+1100_D3wSZ4FjdL/zm5He--
