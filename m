Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYBTKCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYBTKCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYBTKCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:02:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbYBTKCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:02:07 -0500
Date: Wed, 20 Feb 2008 11:01:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, lguest@ozlabs.org
Subject: Re: [PATCH] Fix building lguest as module.
Message-ID: <20080220100139.GB3881@elte.hu>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au> <20080219034404.GT6887@bakeyournoodle.com> <20080219073205.GA12375@elte.hu> <20080219135401.GA9192@elte.hu> <20080219233520.GB6887@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219233520.GB6887@bakeyournoodle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Tony Breeds <tony@bakeyournoodle.com> wrote:

> I've attached the .config FWIW

indeed you are right...

I fixed this build failure too - could you check whether x86.git#test 
(which has all these lguest build fixes) works fine for you:

   http://people.redhat.com/mingo/x86.git/README

? Thanks,

	Ingo
