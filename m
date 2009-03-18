Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZCRAVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZCRAVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZCRAVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:21:09 -0400
Received: from ozlabs.org ([203.10.76.45]:57657 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZCRAVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:21:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PULL] cpumask updates for arm
Date: Wed, 18 Mar 2009 10:51:01 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, travis@sgi.com
References: <200903161444.09281.rusty@rustcorp.com.au> <20090317234018.GA20523@flint.arm.linux.org.uk>
In-Reply-To: <20090317234018.GA20523@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903181051.01499.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009 10:10:18 Russell King wrote:
> On Mon, Mar 16, 2009 at 02:44:08PM +1030, Rusty Russell wrote:
> > The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
> >   Kyle McMartin (1):
> >         parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y
> > 
> > are available in the git repository at:
> > 
> >   ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-arm.git master
> 
> Is there any reason why you've based this tree on mine (with an alternates
> file pointing at my tree?)  After all, the commit which this seems to be
> based upon is one in Linus' tree.

Because I'm an idiot?  At one stage I was going to rebase onto each arch's
tree, but there were too many.  This must be left over from that idle fancy.

Fixed now.

Thanks,
Rusty.
