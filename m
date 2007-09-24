Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbXIXTm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbXIXTm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbXIXTmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:42:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49893 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907AbXIXTmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:42:05 -0400
Date: Mon, 24 Sep 2007 12:38:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-Id: <20070924123842.64cf298b.randy.dunlap@oracle.com>
In-Reply-To: <20070924192504.GB6629@infradead.org>
References: <20070924164950.006047409@polymtl.ca>
	<20070924165428.335030720@polymtl.ca>
	<20070924175044.GD1608@infradead.org>
	<20070924191811.GF28347@Krystal>
	<20070924192504.GB6629@infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 20:25:04 +0100 Christoph Hellwig wrote:

> On Mon, Sep 24, 2007 at 03:18:11PM -0400, Mathieu Desnoyers wrote:
> > > putting code into Documentation is a good idea.  Either of you really
> > > should start a sample/ toplevel directory for this kind of stuff
> > > including a Kconfig menu etc to be able to build these samples as
> > > part of an allmodconfig.
> > > 
> > 
> > One should have a look at Documentation/kprobes.txt for that kind of
> > example code / documentation mix.
> 
> That one is particularly bad.  It's high on my todo list of things to fix.
> -

I already have it split and building.   Just need to know
where to put it.  :)


---
~Randy
Phaedrus says that Quality is about caring.
