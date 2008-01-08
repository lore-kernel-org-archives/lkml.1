Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbYAHWnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbYAHWnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYAHWm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:42:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbYAHWm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:42:58 -0500
Date: Tue, 8 Jan 2008 23:42:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080108224244.GA3768@elte.hu>
References: <patchbomb.1199829603@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1199829603@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> Here's a series which goes some way to tidying up pgtable.h.  It is 
> not complete yet, but this lot compiles and works for me.
> 
> In many cases I've moved code around with no attempt at adjusting the 
> formatting to acceptible style.  That can be done in a later patch, 
> but it means that checkpatch is noisy with this lot.

thanks Jeremy, applied.

	Ingo
