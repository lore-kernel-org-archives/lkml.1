Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbXKKOcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbXKKOcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 09:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXKKOcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 09:32:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbXKKOcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 09:32:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071110114320.1fa6e94c.akpm@linux-foundation.org>
References: <20071110114320.1fa6e94c.akpm@linux-foundation.org> <20071109195303.edbdc631.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153458.20803.10594.stgit@warthog.procyon.org.uk> <24343.1194697130@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the kernel [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sun, 11 Nov 2007 14:32:37 +0000
Message-ID: <1631.1194791557@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> If it is indeed the case that this architecture is used internally by a
> single organisation then perhaps it doesn't make sense for us to merge it.

I don't know that this is so.  I can ask them, but I don't know if they'll
tell me that.

Furthermore, it's better to have the code upstream[*].  That way the person
wanting to make a sweeping change across all arches who knows how the change
should be made can have a go at making the change, rather than someone who's
constantly playing catchup and may not understand fully.

 [*] As people keep saying.

Constantly playing catchup really isn't fun, as I'm sure you appreciate with
maintaining the -mm tree.  You, after all, do it on a much larger scale than
everyone else.

> I guess if it were possible to install a self-built kernel into a Panasonic
> gadget then we could look at it on that basis.  Do you know if that's the
> case?

I don't, no.  Besides, I *do* have Panasonic devices I can install random
software and hardware on to:-)  But it's not COTS stuff.

David
