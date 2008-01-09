Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYAIKsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYAIKsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYAIKs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:48:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59258 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbYAIKs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:48:27 -0500
Date: Wed, 9 Jan 2008 11:48:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109104813.GB14041@elte.hu>
References: <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu> <47841E3C.9020106@goop.org> <20080109011233.GD25945@bingen.suse.de> <478424DE.3030609@goop.org> <20080109014233.GG25945@bingen.suse.de> <478429DE.1090901@goop.org> <20080109021124.GH25945@bingen.suse.de> <47843E06.3070809@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47843E06.3070809@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> OK, great.  Ingo, that means we can use this and go back to folding 
> _PAGE_GLOBAL into __PAGE_KERNEL_*.  Well, at least give it a try.

ok but please send a delta patch for that - the current stuff is 
reasonably stable for the time being.

	Ingo
