Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbYLSCpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbYLSCpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 21:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYLSCpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 21:45:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbYLSCpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:22 -0500
Date: Thu, 18 Dec 2008 18:44:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, sfr@canb.auug.org.au,
       trond.myklebust@fys.uio.no, steved@redhat.com, rwheeler@redhat.com,
       bfields@fieldses.org, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-Id: <20081218184443.d73f5431.akpm@linux-foundation.org>
In-Reply-To: <7633.1229653644@redhat.com>
References: <20081218123601.11810b7f.akpm@linux-foundation.org>
	<8930.1229560221@redhat.com>
	<20081218224418.804f10bc.sfr@canb.auug.org.au>
	<20081218142420.GA16728@infradead.org>
	<7633.1229653644@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 02:27:24 +0000 David Howells <dhowells@redhat.com> wrote:

> > Are any distros pushing for this?  Or shipping it?  If so, are they
> > able to weigh in and help us with this quite difficult decision?
> 
> We (Red Hat) have shipped it in RHEL-5 and some Fedora releases.  Doing so is
> quite an effort, though, precisely because the code is not yet upstream.  We
> have customers using it and are gaining more customers who want it.  There
> even appear to be CentOS users using it (or at least complaining when it
> breaks).

That's useful news.

> 
> I don't know what will convince you.  I've given you theoretical reasons why
> caching ought to be useful; I've backed up the ones I've implemented with
> benchmarks; I've given you examples of what our customers are doing with it or
> want to do with it.

Was that information captured/maintained somewhere?  It really is important (I
think) for something of this magnitude.

> Please help me understand what else you want.

I want to be able to have an answer when someone asks me "why was all that
stuff merged".  One which I can believe.

> Do you perhaps want the netfs maintainers (such as Trond) to say that it's
> necessary?

Of course, their opinions (and supporting explanations) would be valuable.
