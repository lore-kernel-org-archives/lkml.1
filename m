Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbYAaPDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbYAaPDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYAaPDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:03:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYAaPD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:03:29 -0500
Date: Thu, 31 Jan 2008 16:03:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] Remove CONFIG_FORCED_INLINING
Message-ID: <20080131150310.GA10565@elte.hu>
References: <590657100801301437xdf2d140p7a54f90f345022ba@mail.gmail.com> <20080130145034.194a0366@laptopd505.fenrus.org> <1201737631.8837.26.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201737631.8837.26.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Other than the defconfigs, remove the entry in compiler-gcc4.h, 
> Kconfig.debug and feature-removal-schedule.txt.

i've queued up the generic and x86 bits (the arch changes are really 
just to avoid spurious kconfig warnings so it doesnt hurt much), to see 
the effects of this. We can do the rest of your patch later on then.

	Ingo
