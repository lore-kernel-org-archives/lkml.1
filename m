Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYLLTMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYLLTMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYLLTM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:12:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56829 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYLLTM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:12:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.DEB.1.00.0812121952320.5873@eeepc-johanness>
References: <alpine.DEB.1.00.0812121952320.5873@eeepc-johanness> <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
To: Johannes Schindelin <Johannes.Schindelin@gmx.de>
Cc: dhowells@redhat.com, torvalds@osdl.org, git@vger.kernel.org,
       linux-kernel@vger.kernel.org, Miklos Vajna <vmiklos@frugalware.org>
Subject: Re: [PATCH] Simplified GIT usage guide
Date: Fri, 12 Dec 2008 19:12:13 +0000
Message-ID: <29095.1229109133@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Schindelin <Johannes.Schindelin@gmx.de> wrote:

> > +I don't really know what I'm doing with GIT either.
> 
> Strike the "either".

The whole point of the introduction is that this is aimed at someone who
doesn't know what they're doing, so IMO the "either" is quite correct here.

> > +===============
> > +OVERVIEW OF GIT
> > +===============
> 
> Your overview seems to be what "Git from the bottom up" is all about (see 
> the Git Wiki for more information where to find it).

The problem is I need to describe some terminology, and the best way to do
that is with some pictures.  I was wondering if I should break this out into a
separate document and simplify what I keep.

In my opinion, it's much easier to deal with if you can visualise how it
works, even if that visualisation isn't a true representation of reality,
which references Miklos's points.

> From my experience with new users, this is exactly the wrong way to go 
> about it.  You don't introduce object types of the Git database before 
> telling the users what the heck they are good for.  And most users do not 
> need to bother with tree objects either, anyway.  So maybe you just tell 
> them what the heck the object types are good for, without even teaching 
> them the object types at all.

Perhaps.  The main thing I want to introduce is the idea of a tree with three
levels, as it were: commits, directories, files.

> So I think that your document might do a good job scaring people away from 
> Git.  But I do not believe that your document, especially in the tone it 
> is written, does a good job of helping Git newbies.

Hmmm.  So what would you suggest is a good way to write for GIT newbies?  Is
it just that the overview should be canned or drastically simplified?

David
