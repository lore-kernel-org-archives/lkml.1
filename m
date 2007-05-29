Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbXE2Xuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbXE2Xuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXE2XuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:50:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbXE2XuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:50:13 -0400
Message-ID: <465CB524.4020006@redhat.com>
Date: Tue, 29 May 2007 16:20:04 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070529230931.GL7875@mami.zabbo.net>
In-Reply-To: <20070529230931.GL7875@mami.zabbo.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Zach Brown wrote:
> That todo item
> about producing documentation and distro kernels is specifically to bait
> Uli into trying to implement posix aio on top of syslets in glibc.

Get DaveJ to pick up the code for Fedora kernels and I'll get to it.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGXLUk2ijCOnn/RHQRAjL0AJ0UQzNnMn8xpj7ga0OeEWUhnkhZfgCfTH+j
iQ52SLZgWwp4wmAGCy/eLZs=
=hpyn
-----END PGP SIGNATURE-----
