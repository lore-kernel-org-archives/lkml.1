Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbYFTOXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbYFTOXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYFTOXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:23:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996AbYFTOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:23:40 -0400
Date: Fri, 20 Jun 2008 16:23:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Unify crashkernel reservation for 32 and 64 bit
Message-ID: <20080620142328.GG8135@elte.hu>
References: <1213969102-17400-1-git-send-email-bwalle@suse.de> <20080620135847.GE8135@elte.hu> <20080620160645.4b793593@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620160645.4b793593@halley.suse.de>
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


* Bernhard Walle <bwalle@suse.de> wrote:

> >   http://people.redhat.com/mingo/tip.git/README
> 
> That applies here without problems.

oops, you are right - i was on -git and didnt notice! Sorry :-)

	Ingo
