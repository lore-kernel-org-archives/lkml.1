Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbYLLTDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbYLLTDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYLLTDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:03:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54499 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYLLTDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:03:23 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081212185347.GK5691@genesis.frugalware.org>
References: <20081212185347.GK5691@genesis.frugalware.org> <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
Date: Fri, 12 Dec 2008 19:02:41 +0000
Message-ID: <28996.1229108561@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Vajna <vmiklos@frugalware.org> wrote:

> This is incorrect, a 'blob' contains only the contents of the blob, the
> file mode is stored in the 'tree' object.

It seems I understand GIT's database less well than I thought.

> Is there any reason you hide the tag object?

What's a tag object?

> Using git clone --mirror would be much efficient, I think.

	warthog>man git-clone | grep mirror
	warthog1>

> Here and later below, IIRC -l is the default for local clones.

Okay.

> --bare implies -n.

Obvious.

> Why not using git stash and git stash pop?

I didn't know such existed.  That's why I want a crib sheet.

David
