Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZIXJXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZIXJXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZIXJXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:23:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52601 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZIXJX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:23:29 -0400
Date: Thu, 24 Sep 2009 19:23:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stefani Seibold <stefani@seibold.net>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20090924192325.e3416226.sfr@canb.auug.org.au>
In-Reply-To: <20090924083309.GA14270@elte.hu>
References: <20090924140738.3b8ab138.sfr@canb.auug.org.au>
	<20090924083309.GA14270@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Sep_2009_19_23_25_+1000_Cm+0K7N/+L9vMGyW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Sep_2009_19_23_25_+1000_Cm+0K7N/+L9vMGyW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Thu, 24 Sep 2009 10:33:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> Thanks - that's how i fixed it up yesterday, and it tested fine. Have=20
> just pushed out this resolution, so the conflict should disappear from=20
> linux-next tomorrow.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Sep_2009_19_23_25_+1000_Cm+0K7N/+L9vMGyW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq7Oo0ACgkQjjKRsyhoI8xHcwCffDHlCIHemwz9Knn8f7KxA94J
Q0MAoLoEw2wf68W54colOZNP/NP8k226
=OU1e
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Sep_2009_19_23_25_+1000_Cm+0K7N/+L9vMGyW--
