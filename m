Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbZJGHiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbZJGHiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbZJGHix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:38:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52731 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018AbZJGHix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:38:53 -0400
Date: Wed, 7 Oct 2009 09:38:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 00/25] Starting TOMOYO 2.3
Message-ID: <20091007073806.GC31245@elf.ucw.cz>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp> <20091006093922.GB1363@ucw.cz> <200910070409.n9749OQ1092174@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910070409.n9749OQ1092174@www262.sakura.ne.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-10-07 13:09:24, Tetsuo Handa wrote:
> Hello.
> 
> Pavel Machek wrote:
> >> Since this patchset is not yet accepted, I haven't written documentation for
> >> TOMOYO 2.3. You can see http://tomoyo.sourceforge.jp/1.7/policy-reference.html
> >> instead.
> >
> >New, undocumented user/kernel api is no-no.
> 
> I'll update api description by final submission.

Well, then you'll get proper review by final submission.

> >> Conventionally, patches should be submitted in the form of diff file.
> >> But this time, I submit in the form of entire file due to amount of changes.
> >
> > That's also no-no.
> 
> I have a question.
> Is the diff file based on existing files more preferable for reviewers to
> review than totally rewritten files, even if "total lines of diff files" is
> close to "total lines of rewritten files"?

You are expected to submit diffs in smaller steps, not "here it is,
totally rewritten, take it or leave it".
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
