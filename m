Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZJNEou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZJNEou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZJNEot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:44:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2130 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbZJNEot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:44:49 -0400
Subject: Re: [PATCH] kernel.h: Add a never optimized away pr_dbg for
 printk(KERN_DEBUG pr_fmt(fmt)...)
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0910132124120.2044@chino.kir.corp.google.com>
References: <1255488982.1909.26.camel@Joe-Laptop.home>
	 <alpine.DEB.1.00.0910132031040.1244@chino.kir.corp.google.com>
	 <1255494109.1851.7.camel@Joe-Laptop.home>
	 <alpine.DEB.1.00.0910132124120.2044@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Oct 2009 21:44:12 -0700
Message-Id: <1255495452.1851.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 21:28 -0700, David Rientjes wrote:
> The pr_dbg_* variations seem reasonable if the current pr_debug() were 
> changed to pr_dbg().

I think that's unlikely to happen.

> this discussion is irrelevant if there 
> are no current use cases (in which case the patch is pointless).

Yeah, right.  It's alway irrelevant to add new
facilities when where are no current use cases.

I sent a 21 deep patchset over a week ago.
http://lkml.org/lkml/2009/10/4/198


