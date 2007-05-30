Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbXE3BMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbXE3BMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXE3BMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:12:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbXE3BMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:12:37 -0400
Date: Tue, 29 May 2007 21:11:08 -0400
From: Dave Jones <davej@redhat.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070530011108.GA2794@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ulrich Drepper <drepper@redhat.com>,
	Zach Brown <zach.brown@oracle.com>, Jeff Garzik <jeff@garzik.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@zip.com.au>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Davide Libenzi <davidel@xmailserver.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070529230931.GL7875@mami.zabbo.net> <465CB524.4020006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465CB524.4020006@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 04:20:04PM -0700, Ulrich Drepper wrote:
 > -----BEGIN PGP SIGNED MESSAGE-----
 > Hash: SHA1
 > 
 > Zach Brown wrote:
 > > That todo item
 > > about producing documentation and distro kernels is specifically to bait
 > > Uli into trying to implement posix aio on top of syslets in glibc.
 > 
 > Get DaveJ to pick up the code for Fedora kernels and I'll get to it.

With F7 out the door, I'm looking at getting devel/ back in shape again,
so I can get something done there soon-ish.  With the usual caveat that if
this isn't upstream by the time we do a release, we'll have to drop it
due to the added syscall. (Maybe we can just get that reserved upstream now?)

	Dave

-- 
http://www.codemonkey.org.uk
