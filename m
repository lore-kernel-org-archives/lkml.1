Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYFXHU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYFXHU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYFXHUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:20:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbYFXHUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:20:17 -0400
Date: Tue, 24 Jun 2008 00:20:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: hjk@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio-howto.tmpl: use standard copyright/legal markings
Message-Id: <20080624002005.defb45d3.akpm@linux-foundation.org>
In-Reply-To: <1214190762-26974-1-git-send-email-vapier@gentoo.org>
References: <1214190762-26974-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 23:12:42 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> The Userspace I/O HOWTO document uses straight <sect1> tags and plain text
> to describe copyright/legal information.  It should instead use the
> <copyright> and <legalnotice> tags like all other documents in the kernel.
> 

There are conflicting changes in this file in linux-next.

In late -rc the difference between mainline and linux-next is huge.  It
is better to raise (and test!) patches against linux-next.  That's what
it is for.

> +	<holder>Hans-J__rgen Koch.</holder>
> -      Copyright (c) 2006 by Hans-J__rgen Koch.</para>

Oh dear, that got mangled at your end, or in transmission.  It seems to
be mangled in mainline too.   This happens a lot.
