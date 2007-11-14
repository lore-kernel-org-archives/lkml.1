Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbXKNOlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbXKNOlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXKNOk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:40:59 -0500
Received: from twin.jikos.cz ([213.151.79.26]:33427 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbXKNOk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:40:58 -0500
Date: Wed, 14 Nov 2007 15:40:47 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: 2.6.24-rc2-mm1
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711141538250.15844@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, Andrew Morton wrote:

> - To fetch an -mm tree using git, use (for example)
>   git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.16-rc2-mm1

$ git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.24-rc2-mm1
error: no such remote ref refs/tags/v2.6.24-rc2-mm1
fatal: Fetch failure: git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git

I can see the v2.6.24-rc2-mm1 tag on 
http://git.kernel.org/?p=linux/kernel/git/smurf/linux-trees.git;a=summary 
though, so there seems to be something fishy ... ?

-- 
Jiri Kosina
