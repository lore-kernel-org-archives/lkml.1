Return-Path: <linux-kernel-owner+w=401wt.eu-S933526AbZARM1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbZARM1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 07:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759945AbZARM1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 07:27:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52207 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999AbZARM1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 07:27:35 -0500
Date: Sun, 18 Jan 2009 13:27:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v2] fix 41 'make headers_check' warnings
Message-ID: <20090118122720.GB3508@elte.hu>
References: <1232281205.3130.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232281205.3130.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4805]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Ingo,
> 
> These patches are independent to each other, if there is some issue you 
> can drop that patch.

please put the patches that are still under discussion into another branch 
and only offer those for a pull which looked good, ok?

	Ingo
