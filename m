Return-Path: <linux-kernel-owner+w=401wt.eu-S1751369AbZIPEQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbZIPEQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZIPEQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:16:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbZIPEQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:16:18 -0400
Date: Tue, 15 Sep 2009 21:15:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, dedekind1@gmail.com,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org, kmpark@infradead.org,
       linux-mtd@lists.infradead.org
Subject: Re: 2.6.32 -mm merge plans
Message-Id: <20090915211558.85a7825a.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0909152051s4a25b9eej581c68a3b10fda3@mail.gmail.com>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
	<20090916000357.GD23923@linux-sh.org>
	<20090915171826.4bd7f1d4.akpm@linux-foundation.org>
	<8bd0f97a0909152051s4a25b9eej581c68a3b10fda3@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 23:51:25 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> > I don't think that Artem's tree is in linux-next, so I have no
> > visibility of what's happening with that patch.
> >
> > I do think that Artem's tree should be in linux-next.
> >
> > I guess I'll just hose the patch at dwmw2 and will see what happens. __I
> > sent it on Aug 6, with no effect.
> 
> i guess i shouldnt try and bounce a few more mtd patches through you huh ...

You can try.  One of my functions is pointlessly sending patches at
maintainers so you don't have to.

> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=shortlog;h=for-mtd
> 
> hopefully they make it in this cycle (they were posted a while ago to
> the mtd lists w/feedback addressed)

Wanna mail them out in the usual fashion?
