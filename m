Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZHLNzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZHLNzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 09:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZHLNzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 09:55:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40412 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZHLNzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 09:55:05 -0400
Date: Wed, 12 Aug 2009 10:54:39 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [GIT PULL v2] perf tools: Factorize common code
Message-ID: <20090812135439.GD3180@ghostprotocols.net>
References: <20090812100851.GA18577@elte.hu> <1250074112-15147-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250074112-15147-1-git-send-email-fweisbec@gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 12, 2009 at 12:48:29PM +0200, Frederic Weisbecker escreveu:
> On Wed, Aug 12, 2009 at 12:08:51PM +0200, Ingo Molnar wrote:
> > yeah. I've zapped those commits from perfcounters/core.
> >
> >       Ingo
> 
> Ok, sorry about that.
> I've rebuilt a clean tree. It should be fine now.
> 
> Thanks.

Thanks a lot for doing this work, I intended to do that but got
sidetracked with symbol resolving neverending corner cases 8)

- Arnaldo
