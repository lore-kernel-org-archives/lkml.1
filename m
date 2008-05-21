Return-Path: <linux-kernel-owner+w=401wt.eu-S937157AbYEUTzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937157AbYEUTzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765571AbYEUTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:55:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764003AbYEUTzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:55:18 -0400
Date: Wed, 21 May 2008 12:54:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: rdunlap@xenotime.net, tytso@mit.edu, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
 indentation of arguments)
Message-Id: <20080521125449.344a445d.akpm@linux-foundation.org>
In-Reply-To: <20080521194522.GA13916@cvg>
References: <12113495282137-git-send-email-kongjianjun@gmail.com>
	<20080521083413.GM28946@ZenIV.linux.org.uk>
	<20080521015037.add0b78e.akpm@linux-foundation.org>
	<20080521103206.GA24545@infradead.org>
	<20080521120939.GF8581@mit.edu>
	<20080521104644.5b6f4e63.akpm@linux-foundation.org>
	<20080521185725.GD6932@cvg>
	<20080521123355.b34f07ad.rdunlap@xenotime.net>
	<20080521194522.GA13916@cvg>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 23:45:22 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Anrew, Randy, you just wrote KernelNewbiesGuide I think ;) There are
> lot of internet sites which could help with what-to-do, and linux-mm.org
> and kernel.bugzilla.org and more BUT what I've tried to say is that we
> really have such document inside kernel tree (it could be really short)
> like:
> 
> Which patches are not good for sending to LKML
> ----------------------------------------------
> 
>  - Plain whitespace cleanup
> 
> Some rules just *known* only if you have an experience in LKML mailing
> but if someone is sending _first_ patch he ever made he just doesn't know
> that. That is all. So we need not a link to some inet resource BUT written
> in file inside of kernel tree. But that is just my (personal) opinion.

Yes, a general GettingStarted document would probably be useful.
It would hopefully have more what-to-do content than what-not-to-do.
