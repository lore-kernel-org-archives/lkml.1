Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYHTKA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYHTKA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYHTJ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:59:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36267 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbYHTJ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:59:43 -0400
Date: Wed, 20 Aug 2008 11:59:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Diggs <kevdig@hypersurf.com>
Cc: linux-kernel@vger.kernel.org, david@fromorbit.com,
       stefanr@s5r6.in-berlin.de, arnd@arndb.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: {NOT a PATCH} Corrections please ...
Message-ID: <20080820095908.GC28492@elte.hu>
References: <48AB73A3.9010404@hypersurf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AB73A3.9010404@hypersurf.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Diggs <kevdig@hypersurf.com> wrote:

> Hi,
>
> 	It was recommended that I use a completion in a driver I am 
> working on.  While figuring out how to use one, I noticed that there 
> was no kernel doc block comments. I am trying to add them. I would 
> rather not have to respin the patch for corrections.

the text looks good to me - but many of the lines are line-wrapped 
(longer than 80 chars) - which should be avoided for free-flowing text.

	Ingo
