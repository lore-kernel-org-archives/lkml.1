Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbXJ2QiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbXJ2QiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXJ2QiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:38:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbXJ2QiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:38:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0710290926140.30120@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710290926140.30120@woody.linux-foundation.org> <20071029152028.14124.50739.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, rpjday@crashcourse.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Permit the memory to be located elsewhere in NOMMU mode
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 29 Oct 2007 16:38:05 +0000
Message-ID: <20174.1193675885@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Do them in the Kconfig language where it belongs, and where it makes much 
> more sense.

That's what I wanted to do, I just didn't realise I could do it.

David
