Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZFWRau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZFWRau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZFWRal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:30:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35055 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZFWRal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:30:41 -0400
Date: Tue, 23 Jun 2009 16:14:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: security: rename ptrace_may_access => ptrace_access_check
Message-ID: <20090623141451.GA8133@redhat.com>
References: <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org> <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org> <20090507102015.GB8901@elte.hu> <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07, James Morris wrote:
>
> On Thu, 7 May 2009, Ingo Molnar wrote:
>
> > > Boot tested with SELinux.
> >
> > thanks! Below are the two patches i wrote and tested.
>
> Do you need these in your tree, or are they ok going into linux-next via
> mine?

James, Ingo, what happend with these renames? I don't see them
in linux/kernel/git/jmorris/security-testing-2.6.git.

I'd like to do some further cleanups on top of these changes,
or if they were dropped, against Linus's tree.

Oleg.

