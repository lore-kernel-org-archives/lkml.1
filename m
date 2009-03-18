Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZCRIwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZCRIwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZCRIv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:51:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:45741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZCRIv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:51:56 -0400
Subject: Re: [PATCH 1/2 -tip] sched: Clean unused fields from struct rq
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Luis Henriques <henrix@sapo.pt>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49C04F5F.1020700@novell.com>
References: <20090318000343.GA2189@hades.domain.com>
	 <1237334969.5189.1242.camel@laptop>
	 <20090318002327.GA2382@hades.domain.com>  <49C04F5F.1020700@novell.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 09:51:48 +0100
Message-Id: <1237366308.5069.73.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 21:33 -0400, Gregory Haskins wrote:

> > I know that changes in ABI shall not break anything, but just increasing the
> > version number will really solve the issue?  Will userspace care for this?
> > On the other hand, just writting 0s does not sound interesting either...
> >
> >   
> Hi Luis,
>   My app does check the version number, so bumping it is probably the
> best solution.   Be sure to keep me in the loop about whether this patch
> gets merged and I will be sure to update it to handle the new version.

Ah, right, you did say something :-)

/me says to himself, read more mail before answering..

