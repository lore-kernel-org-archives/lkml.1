Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbZBYIAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbZBYIAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbZBYIAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:00:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59506 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbZBYIAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:00:39 -0500
Date: Wed, 25 Feb 2009 09:00:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stoyan Gaydarov <stoyboyker@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: tytso@mit.edu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: the -rt patches
Message-ID: <20090225080017.GB15303@elte.hu>
References: <6d291e080902242351p191bf3cdh2422824b5a2ce82f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d291e080902242351p191bf3cdh2422824b5a2ce82f@mail.gmail.com>
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


* Stoyan Gaydarov <stoyboyker@gmail.com> wrote:

> What is the thing preventing the -rt(real time) patches from 
> making it into the mainline?

There's still a lot of work to be done, so if you want to 
contribute to the -rt project then please read the introduction 
at:

  http://rt.wiki.kernel.org

Also have a look at LKN.net's kernel articles section, there's 
plenty of resources there that explain the current status and 
goals of the -rt project.

	Ingo
