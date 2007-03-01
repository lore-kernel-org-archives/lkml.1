Return-Path: <linux-kernel-owner+w=401wt.eu-S933222AbXCAJgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbXCAJgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933223AbXCAJgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:36:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43156 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222AbXCAJgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:36:39 -0500
Date: Thu, 1 Mar 2007 20:36:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/12] Syslets, Threadlets, generic AIO support, v5
Message-Id: <20070301203636.910b3828.sfr@canb.auug.org.au>
In-Reply-To: <20070228213938.GA945@elte.hu>
References: <20070228213938.GA945@elte.hu>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Mar_2007_20_36_36_+1100_v.E66a8qKymIofAg"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Mar_2007_20_36_36_+1100_v.E66a8qKymIofAg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Wed, 28 Feb 2007 22:39:38 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
>  - 32-bit user-space on 64-bit kernel compat support. 32-bit syslet and
>    threadlet binaries work fine on 64-bit kernels.

Yay!  :-)

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Mar_2007_20_36_36_+1100_v.E66a8qKymIofAg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF5p6sFdBgD/zoJvwRAoUbAJ43+f1ubR95PifShQsGi6eVmwjHeACfU+/9
LQ4bdkr901zB2+Qe+M87zHM=
=j/YO
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Mar_2007_20_36_36_+1100_v.E66a8qKymIofAg--
