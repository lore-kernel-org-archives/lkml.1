Return-Path: <linux-kernel-owner+w=401wt.eu-S933184AbXBRKbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbXBRKbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 05:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXBRKbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 05:31:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37560 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933184AbXBRKbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 05:31:33 -0500
Date: Sun, 18 Feb 2007 21:31:49 +1100
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
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/14] Syslets, generic asynchronous system call
 support, v2
Message-Id: <20070218213149.131830be.sfr@canb.auug.org.au>
In-Reply-To: <20070215165151.GA4285@elte.hu>
References: <20070215165151.GA4285@elte.hu>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__18_Feb_2007_21_31_49_+1100_HLzQpMDD4LknhRcW"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__18_Feb_2007_21_31_49_+1100_HLzQpMDD4LknhRcW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Thu, 15 Feb 2007 17:51:51 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
>
> this is the v2 release of the syslet subsystem. This is an interim
> release, not all known and pending items are fixed/changed yet - the
> tree is still work in progress:
>
>    http://redhat.com/~mingo/syslet-patches/

So, has anyone thought about all those 32bit processes running on a 64bit
kernel and how we are going to cope with this interface?

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__18_Feb_2007_21_31_49_+1100_HLzQpMDD4LknhRcW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF2CsbFdBgD/zoJvwRAtCEAKCeRsYOu3FdllpjFchjpdpxng6hSACfQFUm
VdObkxHE4dOiPe+xtsv0T6Y=
=Q7NZ
-----END PGP SIGNATURE-----

--Signature=_Sun__18_Feb_2007_21_31_49_+1100_HLzQpMDD4LknhRcW--
