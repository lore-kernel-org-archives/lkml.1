Return-Path: <linux-kernel-owner+w=401wt.eu-S933164AbZJFUY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbZJFUY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbZJFUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:24:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33601 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006AbZJFUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:24:27 -0400
Date: Tue, 6 Oct 2009 11:39:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 00/25] Starting TOMOYO 2.3
Message-ID: <20091006093922.GB1363@ucw.cz>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004124946.788396453@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-10-04 21:49:46, Tetsuo Handa wrote:
> Hello.
> 
> This is the beginning of TOMOYO 2.3. TOMOYO 2.2 (which is in kernel 2.6.30 and
> later) is terribly lacking in functionality (e.g. no audit logs, no network).
> I hope TOMOYO 2.3 can provide practically sufficient functionality.
...
> Since this patchset is not yet accepted, I haven't written documentation for
> TOMOYO 2.3. You can see http://tomoyo.sourceforge.jp/1.7/policy-reference.html
> instead.

New, undocumented user/kernel api is no-no.

> Conventionally, patches should be submitted in the form of diff file.
> But this time, I submit in the form of entire file due to amount of changes.

That's also no-no.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
