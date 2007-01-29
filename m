Return-Path: <linux-kernel-owner+w=401wt.eu-S933272AbXA2IrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbXA2IrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933274AbXA2IrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:47:18 -0500
Received: from ns2.suse.de ([195.135.220.15]:57601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272AbXA2IrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:47:17 -0500
From: Andi Kleen <ak@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [patch] i386: add option to show more code in oops reports
Date: Mon, 29 Jan 2007 04:44:21 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>
References: <45B7C019.1040209@redhat.com> <20070125145504.c8c0a98a.akpm@osdl.org> <45B943B7.8070500@redhat.com>
In-Reply-To: <45B943B7.8070500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701290444.21861.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 00:56, Chuck Ebbert wrote:

> Can't think of a way to word the justification, but I've wanted to see more
> code a few times.

Hmm, not sure I see the point. The Code line is just that you can
make sense of random mailing list oopses where you don't
have a vmlinux. But as long as you don't make the option
the default you would need to ask people to set it for you -- and when you
ask you could always as well ask about the vmlinux and get
as much code as you ever wanted.

So unless it's default it's likely useless and I don't think
it is a good idea to make it default because oops screen estate
is so precious.

-Andi

