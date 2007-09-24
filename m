Return-Path: <linux-kernel-owner+w=401wt.eu-S1762712AbXIXTSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762712AbXIXTSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXIXTSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:18:14 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:40360 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbXIXTSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:18:13 -0400
Date: Mon, 24 Sep 2007 15:18:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-ID: <20070924191811.GF28347@Krystal>
References: <20070924164950.006047409@polymtl.ca> <20070924165428.335030720@polymtl.ca> <20070924175044.GD1608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924175044.GD1608@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:16:44 up 56 days, 19:35,  6 users,  load average: 1.43, 0.91, 0.90
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Sep 24, 2007 at 12:49:56PM -0400, Mathieu Desnoyers wrote:
> > Here is some documentation explaining what is/how to use the Linux
> > Kernel Markers.
> 
> As mentioned in the tracing infrastructure thread I don't think
> putting code into Documentation is a good idea.  Either of you really
> should start a sample/ toplevel directory for this kind of stuff
> including a Kconfig menu etc to be able to build these samples as
> part of an allmodconfig.
> 

One should have a look at Documentation/kprobes.txt for that kind of
example code / documentation mix.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
