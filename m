Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZDLJZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZDLJZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 05:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757945AbZDLJZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 05:25:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48086 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634AbZDLJZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 05:25:39 -0400
Date: Sun, 12 Apr 2009 11:25:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC 0/3] Improvements to the tracing documentation
Message-ID: <20090412092524.GA30349@elte.hu>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239479479-2603-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Ts'o <tytso@mit.edu> wrote:

> At the kernel panel at the Linux Foundation Collaboration 
> Summit, I mentioned that the documentation for the tracing 
> subsystem could be improved; in particular, that very 
> often the needed documentation for how the various tracers 
> worked could only be found in the git commit logs, Kconfig 
> files, and of course, reading the source.
> 
> Since criticisms should be followed up with some attempts 
> to improve the situation, here are some patches to improve 
> the tracing documentation.
> 
> I'm not sure the documentation is 100% correct, but by 
> submitting it, hopefully that the tracer authors will get 
> flushed out of the woodwork and be inspired to improve 
> what has been submitted.  :-)

Applied, thanks Ted!

Patch #1 was already present in the tracing tree - i've 
added both the event and the power tracer docs to 
Documentation/trace/.

	Ingo
