Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbXK1BEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbXK1BEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 20:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbXK1BDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 20:03:50 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:52677 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbXK1BDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:03:49 -0500
From: Wagner Ferenc <wferi@niif.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: bonding sysfs output
References: <87tznafjeu.fsf@szonett.ki.iif.hu>
	<20071125205150.4e49915f.akpm@linux-foundation.org>
	<87lk8lflzf.fsf@szonett.ki.iif.hu>
	<20071127004445.a046f791.akpm@linux-foundation.org>
	<87prxwnh9g.fsf@tac.ki.iif.hu>
	<20071127021418.8a05d225.akpm@linux-foundation.org>
Date: Wed, 28 Nov 2007 02:03:44 +0100
In-Reply-To: <20071127021418.8a05d225.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 27 Nov 2007 02:14:18 -0800")
Message-ID: <87oddfji4v.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 27 Nov 2007 10:56:43 +0100 Ferenc Wagner <wferi@niif.hu> wrote:
>
>>> - raise patches against the latest Linus tree
>>> (ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/)
>> 
>> I thought it was better to change to git.  Isn't it so?
>> SubmittingPatches has nothing to say about that...
>> Can I find collected best practices somewhere?  Which tree, which
>> branch, how/when to rebase, format-patch, etc...
>
> gosh.  Documentation/Submit*,
> http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt,
> http://linux.yyz.us/patch-format.html, other places.  Probably people have
> written books about it by now.  But don't sweat it - you're close enough ;)

I wonder where the information got lost...  I miss docs on submitting
patches from git ONLY.  The general documentation is pretty good and
helpful, just doesn't treat git (not using git in general, but using
it for submitting patches to the Linux kernel).  On the other hand
there's a multitude of repositories to clone times a zillion branches
to follow.  Which should be the basis of the patches?  That's not very
clear.

Anyway, find them in my previous mails.  Too bad I realised just after
the fact that cosmetic changes should go first.  Hope it's mostly OK.
-- 
Regards,
Feri.
