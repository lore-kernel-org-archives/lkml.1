Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbXBNDLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbXBNDLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 22:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932294AbXBNDLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 22:11:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbXBNDLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 22:11:05 -0500
Date: Tue, 13 Feb 2007 19:10:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: ericvh@gmail.com, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net
Subject: Re: [RESEND][PATCH] 9p: add write-cache support to loose cache mode
Message-Id: <20070213191055.4db490a1.akpm@linux-foundation.org>
In-Reply-To: <45D27C88.5030605@yahoo.com.au>
References: <11714109311262-git-send-email-ericvh@gmail.com>
	<20070213161607.0ca21ea4.akpm@linux-foundation.org>
	<a4e6962a0702131807n30b08dd6na2e0bbd53c6b9600@mail.gmail.com>
	<20070213181155.f7eebd83.akpm@linux-foundation.org>
	<45D27C88.5030605@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 14 Feb 2007 14:05:44 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > libfs.c is wrong.  Nick has fixes, but they got tangled up in other stuff.
> 
> Yeah. 1/9 in that series should be applied on its own and sent upstream.
> 
> Need me to resend?

Yes please.
