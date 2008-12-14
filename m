Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbYLNBqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbYLNBqF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 20:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYLNBpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 20:45:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:61021 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYLNBpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 20:45:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nmD7ik1HnGXA7M7fIsSa77pII5Hif0QbrLAYm+Agf5ciqPIJL7P/3E3JRtNlfq3B+9
         U0sL8i9sKQYO/Iwxncy8yS0cpJhWlFCgWCmIxRzxCFst3RCGvzTRxwjpjCn7rtTol2wm
         ekCDnah90FsTKW5O4sM9AzLdeHpAKr6sZm2Q0=
Message-ID: <46dff0320812131745h3d30738ajf704a4336f5dec40@mail.gmail.com>
Date: Sun, 14 Dec 2008 09:45:49 +0800
From: "Ping Yin" <pkufranky@gmail.com>
To: "Nick Andrew" <nick@nick-andrew.net>
Subject: Re: [PATCH] Simplified GIT usage guide
Cc: "David Howells" <dhowells@redhat.com>,
       "Johannes Schindelin" <Johannes.Schindelin@gmx.de>, torvalds@osdl.org,
       git@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Miklos Vajna" <vmiklos@frugalware.org>
In-Reply-To: <20081213230504.GA21912@mail.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0812121952320.5873@eeepc-johanness>
	 <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
	 <29095.1229109133@redhat.com>
	 <20081213230504.GA21912@mail.local.tull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 7:05 AM, Nick Andrew <nick@nick-andrew.net> wrote:
> The way I did it was to start with the directed acyclic graph of
> commits, explaining how branches fork the graph and merges join
> it. This was presented to people who know subversion, and so they
> immediately became aware that there are other ways to manage source
> code than in a linear r1 r2 r3 r4 r5. I described tags and branch
> heads briefly.
>
> Next up I described the things you'd do with git: add new commits,
> create a branch, merge a branch, rebase, tag, push and fetch and
> showed what that does with the dag of commits.
>
> Finally I showed the actual commands used to perform those actions.
> I didn't get into the object database structure at all (that was
> prepared in case I had extra time).
>

I think this is the right way to start with the DAG. And i do the same.
