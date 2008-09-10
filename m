Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbYIJSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbYIJSGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYIJSGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:06:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbYIJSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:06:41 -0400
Date: Wed, 10 Sep 2008 11:06:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] UDF fix for 2.6.27-rc5
In-Reply-To: <20080910090620.GB19506@duck.suse.cz>
Message-ID: <alpine.LFD.1.10.0809101105240.3384@nehalem.linux-foundation.org>
References: <20080910090620.GB19506@duck.suse.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Sep 2008, Jan Kara wrote:
> 
>   would you please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus
> 
>   to get the following fix:
> 
> Christoph Hellwig (1):
>       udf: add llseek method
> 
>  fs/udf/file.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

This is not AT ALL what I get when I pull. I get

  udf: Fix error paths in udf_new_inode()
  udf: Fix lock inversion between iprune_mutex and alloc_mutex (v2)

which is

 fs/udf/ialloc.c |   44 +++++++++++++++++++-------------------------
 1 files changed, 19 insertions(+), 25 deletions(-)

Hmm?

Not pulled.

		Linus
