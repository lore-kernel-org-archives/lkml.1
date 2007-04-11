Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbXDKSDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbXDKSDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXDKSDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:03:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbXDKSDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:03:07 -0400
Date: Wed, 11 Apr 2007 11:02:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] markers-linker-generic
Message-Id: <20070411110240.537ee25d.akpm@linux-foundation.org>
In-Reply-To: <20070411175110.GA30879@Krystal>
References: <20070410223658.GC7092@Krystal>
	<20070411074414.GC3752@flint.arm.linux.org.uk>
	<20070411175110.GA30879@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 13:51:11 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > What's this marker stuff about?
> > 
> 
> Hi Russel,
> 
> Here is an overview :

I am told that the systemtap developers plan to (or are) using this
infrastructure.

If correct: what is their reason for preferring it over kprobes?


Secondly, the code in -mm has no actual backend for delivering anything to
userspace or to anywhere else.  Why is this?  Which backends currently
exist, and which ones are envisaged?  Is there a plan to merge any backend
into the mainline kernel?

