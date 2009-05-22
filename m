Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZEVAT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZEVAT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 20:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZEVATs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 20:19:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50655 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZEVATs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 20:19:48 -0400
Date: Fri, 22 May 2009 10:19:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip-core tree with Linus' tree
Message-Id: <20090522101939.0cba91da.sfr@canb.auug.org.au>
In-Reply-To: <4A14D0FF.60202@us.ibm.com>
References: <20090521113902.3deb5031.sfr@canb.auug.org.au>
	<4A14D0FF.60202@us.ibm.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_May_2009_10_19_39_+1000_1yH3f21gpKXWv0LD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_May_2009_10_19_39_+1000_1yH3f21gpKXWv0LD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Darren,

On Wed, 20 May 2009 20:56:47 -0700 Darren Hart <dvhltc@us.ibm.com> wrote:
>
> I suspect Thomas will be catching that up in the next day or so in tip
> (or I can).  If you need something now, the uaddr is VERIFY_READ and
> uaddr2 is VERIFY_WRITE.  See below...

I have made the changes you suggested for today since the -tip stuff has
filtered through yet.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_May_2009_10_19_39_+1000_1yH3f21gpKXWv0LD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoV75sACgkQjjKRsyhoI8zy2gCeP6OCTZIBEM77v95RIsYx57qv
C5EAoI/FFthDbxEwRryOV5LhoYARpjYr
=915x
-----END PGP SIGNATURE-----

--Signature=_Fri__22_May_2009_10_19_39_+1000_1yH3f21gpKXWv0LD--
