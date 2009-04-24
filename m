Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZDXN3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZDXN3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 09:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZDXN3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 09:29:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:45079 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239AbZDXN3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:29:30 -0400
Date: Fri, 24 Apr 2009 09:26:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tytso@mit.edu
Subject: Re: [PATCH] documentation: list common guidelines for commit log
	content
Message-ID: <20090424132655.GA4132@windriver.com>
References: <1239908456-24871-1-git-send-email-paul.gortmaker@windriver.com> <20090423170827.47618b4e@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423170827.47618b4e@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 24 Apr 2009 13:27:37.0854 (UTC) FILETIME=[6F76B9E0:01C9C4E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] documentation: list common guidelines for commit log content] On 23/04/2009 (Thu 17:08) Jonathan Corbet wrote:

> On Thu, 16 Apr 2009 15:00:56 -0400
> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
> > Recent discussions on lkml have brought to light that it is
> > probably worthwhile documenting some of the common (yet up to
> > now implicit) requirements that exist for commit log content.
> > This is by no means exhaustive, but it is a start.
> 
> Sorry I sat on this for a week; I've not ignored it.
> 
> The change made me uncomfortable, despite the fact that I didn't really
> disagree with anything in it.  I guess I feel that there's only so far
> that it makes sense to go with big long lists of do's and don't's.
> That document is plenty long already...  So I put together something
> shorter which tries to focus on the problem at a higher level.  

Fine by me.  I agree that not everything can live in the kernel, and
long lists can test the limits of a person's attention span.  I've
found value in using such a list internally, so thought it worth
sharing.  If nothing else, people can reference the list via a mailing
list archive or similar now.

Paul.

> 
> But maybe others disagree?
> 
> Thanks,
> 
> jon
