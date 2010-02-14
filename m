Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab0BNXnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:43:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52073 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0BNXnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:43:10 -0500
Date: Mon, 15 Feb 2010 10:43:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 27/35] core: move early_res
Message-Id: <20100215104303.428fab25.sfr@canb.auug.org.au>
In-Reply-To: <20100214170858.GA29006@elte.hu>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
	<1265793639-15071-28-git-send-email-yinghai@kernel.org>
	<20100215011615.e3d35121.sfr@canb.auug.org.au>
	<20100214170858.GA29006@elte.hu>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Feb_2010_10_43_03_+1100_KrLaQO2bmo1.Uhnp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Feb_2010_10_43_03_+1100_KrLaQO2bmo1.Uhnp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Sun, 14 Feb 2010 18:08:58 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> FYI, i already found this and reported it to Yinghai earlier today.

Great, thanks.

> Btw.,are you doing these cross-build tests yourself, or are you relaying =
the=20
> kisskb automation notifications?

Mostly they are from the kisskb builds.  Did Michael get the automatic
notification stuff to work (he is on leave so I can't ask him)?  If so, I
will stop reporting these except when I get them myself.

Thanks for all the work.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Feb_2010_10_43_03_+1100_KrLaQO2bmo1.Uhnp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt4iocACgkQjjKRsyhoI8yA/wCgqeKBjI3VFyT4IBTrsabmEBw4
TFAAn2wKbTh7iqyb08Zmu93gvmuW3K6X
=86QC
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Feb_2010_10_43_03_+1100_KrLaQO2bmo1.Uhnp--
