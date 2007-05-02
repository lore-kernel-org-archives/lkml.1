Return-Path: <linux-kernel-owner+w=401wt.eu-S1766762AbXEBTfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766762AbXEBTfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766752AbXEBTfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:35:01 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766742AbXEBTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:34:54 -0400
Date: Wed, 2 May 2007 12:33:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Dean Nelson <dcn@sgi.com>, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: "partical" kthread conversion
Message-Id: <20070502123359.e82a668d.akpm@linux-foundation.org>
In-Reply-To: <m11whzxp0d.fsf@ebiederm.dsl.xmission.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<20070501084245.GA14364@infradead.org>
	<20070501015141.f09f6dde.akpm@linux-foundation.org>
	<20070502140115.GA23595@sgi.com>
	<m11whzxp0d.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2007 08:45:54 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Dean Nelson <dcn@sgi.com> writes:
> 
> > On Tue, May 01, 2007 at 01:51:41AM -0700, Andrew Morton wrote:
> >> > There's probably a few more patches falling into this category, these
> >> > were just the first one the stick into my eye.
> >> 
> >> Yes, I think I'll probably drop all of them - I've completely lost track of
> >> which ones are complete, which ones need more work, etc.
> 
> Andrew as far as dropping them.  If all you have is one of my dinky patches
> that changes things to use kthread_run feel free, because of the general
> necessity of calling kthread_stop I'm going to have to rework those anyway,
> and I still have the originals.
> 

I gave up and dropped them all - let's have another run at it.  Possibly
some of them were complete and didn't deserve dropping, in which case you
can send them straight back at me.

