Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbXKTRyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbXKTRyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbXKTRym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:54:42 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:33014 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbXKTRyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:54:41 -0500
Message-ID: <47431F54.9030302@oracle.com>
Date: Tue, 20 Nov 2007 09:54:28 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: drepper@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net>
In-Reply-To: <20071119.235944.82120402.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Ulrich Drepper <drepper@redhat.com>
> Date: Tue, 20 Nov 2007 01:53:14 -0500
> 
> FWIW, I think this indirect syscall stuff is the most ugly interface
> I've ever seen proposed for the kernel.

Well, there's no XML in /proc :) :).

But, yes, I agree that the internal code needs a lot more cleanup before
being considered for merging.

> And I agree with all of the objections raised by both H. Pater Anvin
> and Eric Dumazet.

I'm worried, too.  Do we have a stronger alternative?  I'm all ears,
this isn't really my area of expertise.

- z
