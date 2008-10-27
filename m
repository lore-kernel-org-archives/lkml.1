Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYJ0NNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYJ0NNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYJ0NNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:13:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33763 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbYJ0NNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:13:05 -0400
Date: Tue, 28 Oct 2008 00:12:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: trace: fix printk warning for u64
Message-Id: <20081028001254.7cb224e9.sfr@canb.auug.org.au>
In-Reply-To: <20081027095248.GA6969@elte.hu>
References: <20081027174328.084649ab.sfr@canb.auug.org.au>
	<20081027095248.GA6969@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Oct_2008_00_12_54_+1100_ThDm/7p8YXhGkKMI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Oct_2008_00_12_54_+1100_ThDm/7p8YXhGkKMI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 27 Oct 2008 10:52:48 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> (btw., did the "unify u64 definitions across all platforms" project=20
> get anywhere?)

I think (from a comment from DaveM) that it led into a real mess.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Oct_2008_00_12_54_+1100_ThDm/7p8YXhGkKMI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkFvlYACgkQjjKRsyhoI8ynYwCdG0gCHam9BZe80uPIlI0i8xD/
K94An1jbLLI5bHlaKqpoC9jCgn3Y3HcM
=lzdX
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Oct_2008_00_12_54_+1100_ThDm/7p8YXhGkKMI--
