Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXKTFm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXKTFm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbXKTFmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:42:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbXKTFmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:42:14 -0500
Date: Mon, 19 Nov 2007 21:35:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       steved@redhat.com
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Message-Id: <20071119213513.f3e6e7e1.akpm@linux-foundation.org>
In-Reply-To: <1195413486.7893.16.camel@heimdal.trondhjem.org>
References: <473DA608.1020804@linux.vnet.ibm.com>
	<64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
	<20071117180946.GA14055@elte.hu>
	<20071117101957.7562639d.akpm@linux-foundation.org>
	<64bb37e0711171140w5f1451e0qea081a4fbc7a45f7@mail.gmail.com>
	<20071117230508.GB25905@dyad>
	<64bb37e0711181044s75fd1081sdf44dac2e060d49a@mail.gmail.com>
	<1195413486.7893.16.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 14:18:06 -0500 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> > 
> > Torsten
> 
> I had already fixed that one in my own stack. Attached are the 3 patches
> that I've got. 1 from SteveD, 2 fixes.
> 
> Andrew, could you please unapply the sillyrename patches you've got, and
> apply these 3 instead?

I'd expect to see things like this appear in git-nfs.patch.  Did something change?
