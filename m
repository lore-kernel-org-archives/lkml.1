Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZLIC73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZLIC73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 21:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZLIC71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 21:59:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54430 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590AbZLIC71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 21:59:27 -0500
Date: Wed, 9 Dec 2009 13:59:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: origin (tip) tree build warning
Message-Id: <20091209135925.f371b109.sfr@canb.auug.org.au>
In-Reply-To: <4B1EF303.60208@redhat.com>
References: <20091209104216.94249b11.sfr@canb.auug.org.au>
	<4B1EF303.60208@redhat.com>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Dec_2009_13_59_25_+1100_bD7rkQF0QIT/tx8L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Dec_2009_13_59_25_+1100_bD7rkQF0QIT/tx8L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Masami,

On Tue, 08 Dec 2009 19:44:51 -0500 Masami Hiramatsu <mhiramat@redhat.com> w=
rote:
>
> Ah, this warning has been fixed on tip:perf/urgent by commit be2bf0a2.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Dec_2009_13_59_25_+1100_bD7rkQF0QIT/tx8L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksfEo0ACgkQjjKRsyhoI8yRSACgnSvB3hGqTqY2H759gb4n8Twb
OycAnjnvsrTRNr9G6/hkvX1e0OBhulq0
=lRSX
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Dec_2009_13_59_25_+1100_bD7rkQF0QIT/tx8L--
