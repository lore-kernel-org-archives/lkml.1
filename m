Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbXKAIkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbXKAIkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbXKAIkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:40:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbXKAIkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:40:07 -0400
Date: Thu, 1 Nov 2007 09:39:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fix
Message-ID: <20071101083953.GA10188@elte.hu>
References: <20071029203923.GA9314@elte.hu> <20071029233417.GA14143@elte.hu> <3d8471ca0710300315l62ae1845o782be670e9181f61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0710300315l62ae1845o782be670e9181f61@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0283]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> 2007/10/30, Ingo Molnar <mingo@elte.hu>:
> >  fs/proc/array.c       |    3 ++-
> >  include/linux/sched.h |    2 +-
> >  kernel/fork.c         |    1 +
> >  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> Hello Ingo,
> 
> do you think it would be possible to include the patch in your git 
> pull request emails? Especially when the patch is small like this one.

yeah, will do that in the future.

	Ingo
