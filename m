Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYLLS4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYLLS4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYLLS4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:56:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:44955 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750877AbYLLS4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:56:15 -0500
X-Authenticated: #1490710
X-Provags-ID: V01U2FsdGVkX1/T4W1/GxfTOeb2gFYHL6wLzsQhHzf1Ds4x+Kcdn8
	1K5+QySzzuE+Ef
Date: Fri, 12 Dec 2008 19:57:38 +0100 (CET)
From: Johannes Schindelin <Johannes.Schindelin@gmx.de>
X-X-Sender: user@eeepc-johanness
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
In-Reply-To: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.DEB.1.00.0812121952320.5873@eeepc-johanness>
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 12 Dec 2008, David Howells wrote:

>  Documentation/git-haters-guide.txt | 1283 ++++++++++++++++++++++++++++++++++++

I am sure we want to have something like that in git.git.

> +I don't really know what I'm doing with GIT either.

Strike the "either".

> +===============
> +OVERVIEW OF GIT
> +===============

Your overview seems to be what "Git from the bottom up" is all about (see 
the Git Wiki for more information where to find it).

>From my experience with new users, this is exactly the wrong way to go 
about it.  You don't introduce object types of the Git database before 
telling the users what the heck they are good for.  And most users do not 
need to bother with tree objects either, anyway.  So maybe you just tell 
them what the heck the object types are good for, without even teaching 
them the object types at all.

So I think that your document might do a good job scaring people away from 
Git.  But I do not believe that your document, especially in the tone it 
is written, does a good job of helping Git newbies.

Ciao,
Dscho

P.S.: No, I haven't read the whole document.  Still, I think I am 
qualified enough to estimate what the average reader's first impression 
would be.
