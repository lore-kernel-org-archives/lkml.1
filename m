Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZI3MEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZI3MEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZI3MEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:04:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46862 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZI3MEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:04:43 -0400
Date: Wed, 30 Sep 2009 14:04:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: checkpatch as a tool (was Re: [RFC][PATCH] SCHED_EDF
	scheduling class)
Message-ID: <20090930120406.GD1412@ucw.cz>
References: <1253615424.20345.76.camel@Palantir> <1253625878.6575.34.camel@desktop> <1253628061.20345.173.camel@Palantir> <1253637721.18939.3.camel@laptop> <20090922191117.GB24542@elte.hu> <1253667103.25689.35.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253667103.25689.35.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-22 17:51:43, Daniel Walker wrote:
> On Tue, 2009-09-22 at 21:11 +0200, Ingo Molnar wrote:
> 
> > Now at patch patches/sched_edf-scheduling-class.patch
> > 
> > Daniel is a kind of self-elected joker-bot on lkml, running checkpatch 
> > out of .procmailrc and annoying people with trivial comments, 
> > distracting from the real discussion. Raistlin, feel free to ignore him 
> > in the future.

Good, I was afraid Ingo would actually like that behaviour.

> You want to talk about it constructively or not? I'll stop sending those
> emails if it's actually negative , but I don't think it is..

Getting you 'have misplaced parenthesis' feedback on a bugfix, on a
file thatt has 1001 checkpatch problems, and when the patch does not
actually introduce the problem... certainly is unwelcome.

What about simply avoiding the mails when the file being changed
already has checkpatch problems?
									Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
