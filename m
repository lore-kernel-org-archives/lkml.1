Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140Ab0BYLmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:42:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab0BYLmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:42:36 -0500
Date: Thu, 25 Feb 2010 12:42:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, gorcunov@gmail.com,
       aris@redhat.com
Subject: Re: [PATCH] nmi_watchdog: checkpatch.pl cleanups from earlier patches
Message-ID: <20100225114226.GK10212@elte.hu>
References: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> Mostly copy/paste whitespace damage with a couple of nitpicks by the script.
> Fix the struct definition as requested by Ingo too.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> --
> Ingo,
> 
> I don't know how you want this patch.  Like this to put on top or do you
> want me to repost everything with the cleanups inside the appropriate patch?

It's fine this way - i've put them on top - the base patches have a reasonable 
amount of testing track record already, we dont want to destroy that via a 
rebase.

(in the future it's useful to run checkpatch as part of your patch submission 
checks. In my experience it finds real issues most of the time. Some of the 
warnings have to be ignored.)

	Ingo
