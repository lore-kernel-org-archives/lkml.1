Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbXJXNTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbXJXNTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbXJXNTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:19:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51368 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbXJXNTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:19:41 -0400
Message-ID: <471F4649.3000000@garzik.org>
Date: Wed, 24 Oct 2007 09:19:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/git patch] move samples/ to Documentation/markers/
References: <20071024095226.GA30326@havoc.gtf.org> <20071024130557.GA18610@Krystal>
In-Reply-To: <20071024130557.GA18610@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Honestly, I don't care at all about building the code.  If that's what 
you want, great.

My objection is more to adding a samples/ directory, which is contra to 
past experience:

A new net driver sample should go in drivers/net/ like the existing 
skeleton files I already listed, not samples/net/.  A top-level 
"samples/" seems like it exists only duplicate the rest of the tree 
hierarchy.

	Jeff



