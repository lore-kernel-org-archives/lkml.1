Return-Path: <linux-kernel-owner+w=401wt.eu-S1751693AbZIPOel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbZIPOel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZIPOej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:34:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZIPOei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:34:38 -0400
Date: Wed, 16 Sep 2009 16:34:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] security / creds fixes
Message-ID: <20090916143416.GA16108@elte.hu>
References: <20090914162613.9016.79225.stgit@warthog.procyon.org.uk> <alpine.LRH.2.00.0909151008440.11936@tundra.namei.org> <20090916130224.GA27519@elte.hu> <1253108314.5213.109.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253108314.5213.109.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Paris <eparis@redhat.com> wrote:

> On Wed, 2009-09-16 at 15:02 +0200, Ingo Molnar wrote:
> > i'm still getting crashes even with latest -git [0cb583f]:
> 
> This is something totally different, not quite sure since my system
> doesn't reproduce it.  It's doesn't look like the problem I ran into
> where SLUB couldn't call kmem_cache_destroy at all.  I'll build with
> your config.  I have an idea, I assume this is an SMP machine?

Correct - as can be seen in the full bootlog i have attached to my 
report.

	Ingo
