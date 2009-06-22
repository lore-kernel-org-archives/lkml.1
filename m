Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZFVWjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZFVWjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZFVWjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:39:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53836 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZFVWjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:39:41 -0400
Date: Mon, 22 Jun 2009 21:24:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, jmorris@namei.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Message-ID: <20090622192453.GA6066@redhat.com>
References: <20090413214513.GA1119@redhat.com> <14878.1239876272@redhat.com> <20090416133658.GA6532@redhat.com> <20090416145444.GA12884@redhat.com> <20090618120716.fd1e4d92.akpm@linux-foundation.org> <20090618194238.GA17810@redhat.com> <20090622115148.5f1e5d1b.akpm@linux-foundation.org> <20090622171431.GA5010@redhat.com> <20090622140440.01d85542.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622140440.01d85542.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Andrew Morton wrote:
>
> On Mon, 22 Jun 2009 19:14:31 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Sure, I can split these changes. Or we can just forget about this patch.
>
> noooo the world needs oleg patches.

Yeeeees, I am trying to blackmail ;)

> > But what is the problem with this patch?
>
> The discussion between yourself and David seems to be unresolved, so
> I have it in wait-and-see mode.
>
> > David, do you still dislike ->mmap_sem? I didn't see other objections,
> > and again, imho tasklist_lock is worse.

OK, I'll split and re-send.

Unless David replies.

Oleg.

