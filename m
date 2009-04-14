Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbZDNCTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbZDNCTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZDNCTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:19:16 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3362 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZDNCTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:19:16 -0400
Subject: Re: [PATCH] add ptrace entry to MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, torvalds@osdl.org, roland@redhat.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090414004231.GA17288@elte.hu>
References: <20090413152010.GA16682@lst.de> <20090414004231.GA17288@elte.hu>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 19:17:10 -0700
Message-Id: <1239675430.32203.116.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 02:42 +0200, Ingo Molnar wrote:
> * Christoph Hellwig <hch@lst.de> wrote:
> 
> > At the LF collab summit we decided to make Roland official ptrace
> > maintainer not just the defacto one he has been for a couple of years
> > now.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Hm, what is this "LF collab summit" that makes decisions in terms of 
> who maintains what? Some new buerocracy on top of Linux i have not 
> heard about yet? :)

I think the MAINTAINERS file could
use a new status type.

These are the status types today:

	Supported:	Someone is actually paid to look after this.
	Maintained:	Someone actually looks after it.
	Odd Fixes:	It has a maintainer but they don't have time to do
			much other than throw the odd patch in. See below..
	Orphan:		No current maintainer [but maybe you could take the
			role as you write your new code].
	Obsolete:	Old code. Something tagged obsolete generally means
			it has been replaced by a better system and you
			should be using that.

Maybe it'd be useful to have a defined
aggregator/overseer/gatekeeper role.

Basically what Greg Kroah-Hartman does for staging
and David Miller does for driver/net


