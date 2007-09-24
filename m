Return-Path: <linux-kernel-owner+w=401wt.eu-S1763532AbXIXTZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763532AbXIXTZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762430AbXIXTZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:25:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57715 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763153AbXIXTZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:25:14 -0400
Date: Mon, 24 Sep 2007 20:25:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-ID: <20070924192504.GB6629@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Prasanna S Panchamukhi <prasanna@in.ibm.com>,
	Jim Keniston <jkenisto@us.ibm.com>
References: <20070924164950.006047409@polymtl.ca> <20070924165428.335030720@polymtl.ca> <20070924175044.GD1608@infradead.org> <20070924191811.GF28347@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924191811.GF28347@Krystal>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 03:18:11PM -0400, Mathieu Desnoyers wrote:
> > putting code into Documentation is a good idea.  Either of you really
> > should start a sample/ toplevel directory for this kind of stuff
> > including a Kconfig menu etc to be able to build these samples as
> > part of an allmodconfig.
> > 
> 
> One should have a look at Documentation/kprobes.txt for that kind of
> example code / documentation mix.

That one is particularly bad.  It's high on my todo list of things to fix.
