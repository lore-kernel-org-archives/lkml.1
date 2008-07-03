Return-Path: <linux-kernel-owner+w=401wt.eu-S1761129AbYGCM4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761129AbYGCM4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbYGCM4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:56:04 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:60963 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbYGCM4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:56:03 -0400
Date: Thu, 3 Jul 2008 11:41:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ben Castricum <lk0806@bencastricum.nl>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch] x86: microcode: Cosmetic changes
Message-ID: <20080703094108.GA21456@elte.hu>
References: <alpine.LNX.1.10.0806101312170.14868@gateway.bencastricum.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0806101312170.14868@gateway.bencastricum.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0278]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Castricum <lk0806@bencastricum.nl> wrote:

> First announce ourself, then start working. Currently this module 
> reports itself when all is completed which is not most modules do. 
> Plus some cosmetic/whitespace cleanups.
> 
> Signed-off-by: Ben Castricum <lk0806@bencastricum.nl>

applied to tip/x86/cleanups - thanks Ben,

	Ingo
