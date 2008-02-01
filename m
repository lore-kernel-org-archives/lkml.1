Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYBAPPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYBAPPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbYBAPO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:14:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYBAPOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:14:53 -0500
Date: Fri, 1 Feb 2008 16:14:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Greg Ungerer <gerg@snapgear.com>, Miles Bader <miles@gnu.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] remove the v850 port
Message-ID: <20080201151427.GA32085@elte.hu>
References: <20080120192356.GI8669@does.not.exist> <4793E42B.7080400@snapgear.com> <20080128221320.GI8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128221320.GI8767@does.not.exist>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> Trying to compile the v850 port brings you many compile errors, one of 
> them exists since at least kernel 2.6.19.
> 
> There also seems to be noone willing to bring this port back into a 
> usable state.
> 
> This patch therefore removes the v850 port.

start by putting the intention of removal into:

   Documentation/feature-removal-schedule.txt

we can remove it after that. Same for most of your other removal 
patches.

	Ingo
