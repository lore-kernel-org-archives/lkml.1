Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZK0OWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZK0OWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZK0OWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:22:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZK0OWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 09:22:51 -0500
Date: Fri, 27 Nov 2009 15:17:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091127141709.GA5137@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125214818.GA4916@infradead.org> <20091126091052.GF1389@elte.hu> <20091126104722.GA8316@infradead.org> <20091126122441.GC15189@elte.hu> <20091127140439.GA17000@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127140439.GA17000@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Christoph Hellwig wrote:
>
> On Thu, Nov 26, 2009 at 01:24:41PM +0100, Ingo Molnar wrote:
> >
> > FYI, it's been in -mm, that's where it's maintained.
>
> None of the recent mm snapshots has anything utrace related in there,

Well, not that I think this is important, but...

Two weeks ago we asked Andrew do drop utrace-core.patch from -mm,
it should be replaced by this updated version.

Oleg.

