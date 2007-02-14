Return-Path: <linux-kernel-owner+w=401wt.eu-S932250AbXBNNRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbXBNNRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 08:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254AbXBNNRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 08:17:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34642 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250AbXBNNRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 08:17:19 -0500
Date: Thu, 15 Feb 2007 00:17:38 +1100
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
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-Id: <20070215001738.d58e9a25.sfr@canb.auug.org.au>
In-Reply-To: <20070213142035.GF638@elte.hu>
References: <20060529212109.GA2058@elte.hu>
	<20070213142035.GF638@elte.hu>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Feb_2007_00_17_38_+1100_8CbTvqeSmOGdNwnR"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Feb_2007_00_17_38_+1100_8CbTvqeSmOGdNwnR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hi Ingo,

On Tue, 13 Feb 2007 15:20:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> From: Ingo Molnar <mingo@elte.hu>
>
> the core syslet / async system calls infrastructure code.

It occurred to me that the 32 compat code for 64 bit architectures for
all this could be very hairy  ...

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Feb_2007_00_17_38_+1100_8CbTvqeSmOGdNwnR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF0wv3FdBgD/zoJvwRAoeSAJ0dYWIo/6osWBg4CvNkWdAdj7LY0gCfYAiR
/ba5Xr1c0sdb7b9yj5l1b7Q=
=Jah4
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Feb_2007_00_17_38_+1100_8CbTvqeSmOGdNwnR--
