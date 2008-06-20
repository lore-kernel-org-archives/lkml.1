Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYFTNLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYFTNLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYFTNLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:11:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35757 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbYFTNLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:11:03 -0400
Date: Fri, 20 Jun 2008 15:10:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86: unify asm-x86/fixmap*.h
Message-ID: <20080620131041.GA19740@elte.hu>
References: <4858056D.7000500@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4858056D.7000500@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0116]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Almost everything aside from the actual fixmap slot definitions is 
> common, so move it all into the common fixmap.h header.

nice patches! I have created a new -tip topic for them: tip/x86/fixmap, 
and have added them there. (This topic will also be in auto-x86-next on 
the next integration run.)

	Ingo
