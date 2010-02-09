Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0BIKXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 05:23:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab0BIKXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 05:23:18 -0500
Date: Tue, 9 Feb 2010 11:23:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove reference to kthread_create_on_cpu
In-Reply-To: <201002091604.43557.rusty@rustcorp.com.au>
Message-ID: <alpine.LNX.2.00.1002091122590.30967@pobox.suse.cz>
References: <20100209040740.GB3702@kryten> <201002091604.43557.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010, Rusty Russell wrote:

> > kthread_create_on_cpu doesn't exist so update a comment in kthread.c to
> > reflect this.
> > 
> > Signed-off-by: Anton Blanchard <anton@samba.org>
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
