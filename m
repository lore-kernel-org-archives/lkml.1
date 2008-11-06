Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYKFOzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYKFOzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYKFOz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:55:27 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:45176 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYKFOz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:55:27 -0500
Date: Thu, 6 Nov 2008 08:54:21 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       travis@sgi.com
Subject: Re: Git next: Second stage of cpu_alloc patches
In-Reply-To: <20081106115428.f622e61f.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0811060853320.3595@quilx.com>
References: <Pine.LNX.4.64.0811042053510.31638@quilx.com>
 <20081104195205.fe1bf62b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0811050753120.11867@quilx.com> <20081105235842.GB10909@cmpxchg.org>
 <20081106115428.f622e61f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Stephen Rothwell wrote:

> On Thu, 6 Nov 2008 00:58:42 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Wed, Nov 05, 2008 at 07:54:39AM -0600, Christoph Lameter wrote:
> > > Ok so post a patchset to lkml and at the same time offer a git tree?
> >
> > Git is perhaps a more convenient way to pick up changesets compared to
> > extracting them from emails but review and discussion should still
> > happen by Email, no?
>
> Correct.

So what are the criteria when to repost a patchset? How extensive must the
changes be? This one has just minor fixes to the prior post.


