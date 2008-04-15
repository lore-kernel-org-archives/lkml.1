Return-Path: <linux-kernel-owner+w=401wt.eu-S1765480AbYDOUEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765480AbYDOUEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764895AbYDOUEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:04:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761910AbYDOUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:04:13 -0400
Date: Tue, 15 Apr 2008 13:02:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: hch@infradead.org, bunk@kernel.org, dwmw2@infradead.org, miklos@szeredi.hu,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080415130240.1b9b7662.akpm@linux-foundation.org>
In-Reply-To: <20080415195330.17f63348@the-village.bc.nu>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
	<20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<20080413154459.4b2f125d.akpm@linux-foundation.org>
	<20080413234920.63711ca7@core>
	<20080413161014.cb06964c.akpm@linux-foundation.org>
	<20080415151643.GD2454@cs181133002.pp.htv.fi>
	<20080415165727.GA8783@infradead.org>
	<20080415113452.e9eacb54.akpm@linux-foundation.org>
	<20080415195330.17f63348@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 19:53:30 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > You can continue to ignore my logic, but that won't go unnoticed.
> > 
> > Just as a thought exercise: should we merge a small and well-written
> > driver which has zero users?
> 
> We've previously merged ones that fit this category and have one user.

Probably incorrectly.

> If
> the driver doesn't disrupt core code and is useful to help other people
> write drivers then I think we should. It may also get more users as a
> result.

Maybe.

> This is a free software project not a business enterprise.

And the same principles apply, don't they?  We seek to minimise overhead
and to use our kernel development hours as effectively as we can.

This is particularly important when person A is thrusting additional work
onto persons B, C, and D.

