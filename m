Return-Path: <linux-kernel-owner+w=401wt.eu-S965618AbXBGBC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618AbXBGBC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965613AbXBGBC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:02:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965612AbXBGBC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:02:27 -0500
Date: Tue, 6 Feb 2007 17:01:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tilman Schmidt <tilman@imap.cc>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
       netfilter-devel@lists.netfilter.org
Subject: Re: dynticks + iptables almost stops the boot process [was: Re:
 2.6.20-rc6-mm3]
Message-Id: <20070206170157.114f0e65.akpm@linux-foundation.org>
In-Reply-To: <1170803853.3785.45.camel@chaos>
References: <20070131215241.GB2890@inferi.kami.home>
	<20070131232130.GC4137@inferi.kami.home>
	<1170358572.29240.292.camel@localhost.localdomain>
	<1170360101.29240.297.camel@localhost.localdomain>
	<20070201211137.GA2830@inferi.kami.home>
	<1170369202.29240.339.camel@localhost.localdomain>
	<20070202191802.GA4262@inferi.kami.home>
	<1170448034.29240.364.camel@localhost.localdomain>
	<20070202204344.GB4262@inferi.kami.home>
	<20070206164826.GA3491@elte.hu>
	<20070206192840.GB2971@inferi.kami.home>
	<45C90B57.90104@imap.cc>
	<1170803853.3785.45.camel@chaos>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Feb 2007 00:17:33 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 2007-02-07 at 00:12 +0100, Tilman Schmidt wrote:
> > > No, not this. Anyway the last patch Thomas forwarded does fix the
> > > problem.
> > 
> > Which one would that be? I might try it for comparison.
> 
> Find the combined patch of all fixlets on top of -mm3 below.

err, I don't have most of this.

I just uploaded the crappile-of-the-moment to
   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-06-16-59.tar.gz
