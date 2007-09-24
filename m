Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbXIXR6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbXIXR6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbXIXR6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:58:18 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32675 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbXIXR6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:58:17 -0400
Date: Mon, 24 Sep 2007 10:56:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-Id: <20070924105632.009aba7f.randy.dunlap@oracle.com>
In-Reply-To: <20070924175044.GD1608@infradead.org>
References: <20070924164950.006047409@polymtl.ca>
	<20070924165428.335030720@polymtl.ca>
	<20070924175044.GD1608@infradead.org>
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

On Mon, 24 Sep 2007 18:50:44 +0100 Christoph Hellwig wrote:

> On Mon, Sep 24, 2007 at 12:49:56PM -0400, Mathieu Desnoyers wrote:
> > Here is some documentation explaining what is/how to use the Linux
> > Kernel Markers.
> 
> As mentioned in the tracing infrastructure thread I don't think
> putting code into Documentation is a good idea.  Either of you really
> should start a sample/ toplevel directory for this kind of stuff
> including a Kconfig menu etc to be able to build these samples as
> part of an allmodconfig.

I don't have a problem with a samples/ directory except (as I have
already pointed out) it means that people will end up having to look
in 2 places for the information that they need, i.e., both in
samples/ and in Documentation/.  So I really don't see a big need
to split the samples and docs.

What's wrong with building sample code in the Documentation/ directory?

---
~Randy
Phaedrus says that Quality is about caring.
