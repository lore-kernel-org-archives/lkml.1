Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbXEJMQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbXEJMQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbXEJMQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:16:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36218 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbXEJMQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:16:40 -0400
Date: Thu, 10 May 2007 22:16:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 -- powerpc missing kset
Message-Id: <20070510221631.5eb38bdd.sfr@canb.auug.org.au>
In-Reply-To: <4643068C.8010302@shadowen.org>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	<4643068C.8010302@shadowen.org>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_May_2007_22_16_31_+1000_3HuKn4/ZQPPOnIhR"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2007_22_16_31_+1000_3HuKn4/ZQPPOnIhR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Thu, 10 May 2007 12:48:28 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
>
> arch/powerpc/platforms/pseries/power.c:31: warning: `struct subsystem'
> declared inside parameter list

There is no explicit reference to struct subsystem in the current version
of that file.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_May_2007_22_16_31_+1000_3HuKn4/ZQPPOnIhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGQw0kFdBgD/zoJvwRAvZyAJwM3NoM8kedpL+fUT3LHfI68tDqVACfTHX6
cMfZ2F/JfCoNfCXbEM3DmF0=
=l/Nd
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2007_22_16_31_+1000_3HuKn4/ZQPPOnIhR--
