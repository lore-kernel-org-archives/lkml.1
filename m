Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbXJLK6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbXJLK6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 06:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759792AbXJLK6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 06:58:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759541AbXJLK6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 06:58:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200710120248.05506.nickpiggin@yahoo.com.au>
References: <200710120248.05506.nickpiggin@yahoo.com.au> <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/31] Remove iget() and read_inode() [try #4]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 12 Oct 2007 11:58:02 +0100
Message-ID: <11207.1192186682@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Is there any particular reason not to push these through -mm?

No.

David
