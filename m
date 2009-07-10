Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZGJUkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZGJUkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZGJUkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:40:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:39893 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbZGJUkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:40:10 -0400
Date: Fri, 10 Jul 2009 22:39:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rongrong Cao <rrcao@ambarella.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-2.6.32] sound dapm: fix checking for external widgets
 bug
In-Reply-To: <20090710191925.GA5916@sirena.org.uk>
Message-ID: <alpine.LNX.2.00.0907102238150.4232@jikos.suse.cz>
References: <90B0CE4312136749B97EBEAF5764F87403C8F77A@ambarella-ex.ambarella.net> <20090710191925.GA5916@sirena.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Mark Brown wrote:

> I also notice that you've CCed trivial@kernel.org.  Please don't do that 
> except for things that can't possibly cause bugs - a change like this 
> doesn't really qualify since while the code clearly looks buggy it's 
> always possible that the code is just obscure.

Absolutely. 

Nevertheless, when the patch doesn't qualify for trivial queue, and I see 
proper maintainers being also involved, I just silently skip the patch, 
otherwise I just add proper maintainers to CC and don't apply it to 
trivial queue.

-- 
Jiri Kosina
SUSE Labs
