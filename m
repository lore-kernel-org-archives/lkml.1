Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXC1TYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXC1TYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbXC1TYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:24:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404AbXC1TYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:24:51 -0400
Date: Wed, 28 Mar 2007 21:23:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       e1000-devel@lists.sourceforge.net, jgarzik@pobox.com,
       netdev@vger.kernel.org
Subject: Re: [1/5] 2.6.21-rc5: known regressions
Message-ID: <20070328192327.GA24340@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <460AB9E8.8070803@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460AB9E8.8070803@intel.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> Adrian Bunk wrote:
> >Subject    : e1000 resume weirdness
> >References : http://lkml.org/lkml/2007/3/26/91
> >Submitter  : Ingo Molnar <mingo@elte.hu>
> >Handled-By : Jesse Brandeburg <jesse.brandeburg@gmail.com>
> >             Auke Kok <auke-jan.h.kok@intel.com>
> >Status     : problem is being debugged

> Adrian, you probably want to drop this issue from your list.

agreed - i have done many suspend/resumes meanwhile, and this condition 
has not reoccured since then. (and even when it occured, it was 
transitionary)

	Ingo
