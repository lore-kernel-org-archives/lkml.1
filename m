Return-Path: <linux-kernel-owner+w=401wt.eu-S1762837AbXKHXeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762837AbXKHXeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 18:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXKHXd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 18:33:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbXKHXd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 18:33:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071108220455.GB28242@uranus.ravnborg.org>
References: <20071108220455.GB28242@uranus.ravnborg.org> <20071108182937.GA26852@uranus.ravnborg.org> <20071108171612.26590.4348.stgit@warthog.procyon.org.uk> <16966.1194549065@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 0/6] MN10300: Add the MN10300 architecture to Linux kernel [try #4]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 08 Nov 2007 23:30:49 +0000
Message-ID: <18108.1194564649@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> kbuild does not know anything about ASFLAGS.
> In the whole kernel tree I only see frv assign them but the
> value is never used.

Hmmm... I think it used to be.  No matter, I'll drop it from MN10300.

> It just seemed stupid that someone having copyright on a file
> where the person only had contributed the copyright linei (for said file).

I'll consult MEI as to what boilerplate copyright messages I should plaster on
such files.

David
