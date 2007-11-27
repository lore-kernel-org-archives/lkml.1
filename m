Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbXK0Xwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbXK0Xwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbXK0Xwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:52:47 -0500
Received: from 1wt.eu ([62.212.114.60]:2488 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbXK0Xwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:52:47 -0500
Date: Wed, 28 Nov 2007 00:52:38 +0100
From: Willy Tarreau <w@1wt.eu>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: git guidance
Message-ID: <20071127235237.GF15227@1wt.eu>
References: <474C9B31.8000408@imap.cc> <20071127235511.bd9557f0.Kristoffer.ericson@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127235511.bd9557f0.Kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 11:55:11PM +0100, Kristoffer Ericson wrote:
> Greetings,
> 
> Google is your friend. If you're looking for irc channels you can always try #git at irc.freenode.net
> Git howto/tutorial/... doesn't belong in the kernel mailinglist.

Well, I don't agree with you. His question is about how to use GIT to
develop his driver.
   1) linux-kernel is a development ML.
   2) he needs help from people how already encountered such beginner's
      issues and who might git very good advices.

It should not turn into an endless thread led by people who want to
redefine GIT's roadmap, but experience sharing helps a lot with GIT.

Tilman, there was a howto by Jeff Garzik I believe. It helped me
a lot when I didn't understand a damn command, even if it was in
the very old ages (version 0.5 or something like this). The tutorials
on the GIT site are quite good too. You must read them entirely and
proceed with the examples as you read them. Believe me, it helps you
understand a lot of things, specially about the split in 3 parts
(objects, cache, and working dir).

I really think that if your patches do not apply, it's because you
have lost some changes due to a wrong initial use possibly caused
by a mis-understanding of the tool. It happened to me too, but in
this case you can almost certainly find your old changes in older
commits.

I really hope that soon someone will come up with a big 400-pages
book called "GIT" with a lot of good advices. It would be awesome.

Anyway, don't get demotivated about the tool or the workflow. If
you find it inconvenient to use, you're doing something wrong and
you don't know it.

Regards,
Willy

