Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZFRVl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZFRVl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZFRVlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:41:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbZFRVlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:41:20 -0400
Date: Thu, 18 Jun 2009 14:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tj@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca
Subject: Re: [GIT PULL] percpu for 2.6.31
Message-Id: <20090618143959.62858ef6.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0906181421460.16802@localhost.localdomain>
References: <4A39F5B4.1070305@kernel.org>
	<alpine.LFD.2.01.0906181421460.16802@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 14:22:20 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 18 Jun 2009, Tejun Heo wrote:
> > 
> > Please pull from percpu-for-linus git tree from:
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus
> 
> I'm very unhappy with this kind of crap.

AFACIT none of these patches have ever been in linux-next.  Half or
more of them turned up on the mailing list for the first time two days
ago and there's little evidence that anyone has even looked at them.

If this doesn't mean "you missed 2.6.31" then what does?



Yes, things like this can be messy and hard to develop and maintain
outside the merge window.  We understand this.  There are special
cases.  But when this happens, let's talk about it and see what we can
do!  Please let's not pretend that this is an ordinary old git merge
like all the others.
