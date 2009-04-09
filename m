Return-Path: <linux-kernel-owner+w=401wt.eu-S937500AbZDIXj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937500AbZDIXj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937458AbZDIXjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:39:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37173 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937462AbZDIXji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:39:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0904091628580.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904091628580.4583@localhost.localdomain> <20090409232152.13220.28141.stgit@warthog.procyon.org.uk> <20090409232157.13220.63863.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
Date: Fri, 10 Apr 2009 00:38:17 +0100
Message-ID: <13476.1239320297@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> David, please _look_ at your patches before sending them out.

I did.  I emailed it to myself first, and then accidentally lost the
--diff-opts=-M I'd added when I was trying to email publically.

I think I'd probably better off sticking this in a GIT tree and getting you to
pull it.

David
