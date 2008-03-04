Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYCDN1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYCDN1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYCDN1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:27:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYCDN1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:27:41 -0500
Date: Tue, 4 Mar 2008 14:27:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: devzero@web.de
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, rick@vanrein.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080304132724.GB32383@elte.hu>
References: <182234194@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <182234194@web.de>
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


* devzero@web.de <devzero@web.de> wrote:

> >What is wrong with mem=exactmap?
> 
> probably no ordinary user knows how to use it instead of badram?
> http://lists.opensuse.org/opensuse/2007-04/msg00501.html
> 
> someone please show us how to use that instead of badram or how this 
> can replace what badram does.

as i said it in another reply to this thread, it would be perfectly 
acceptable for upstream to merge an easier to use boot option - be that 
badmem=addr$size or excludemem=addr$size. Please send a patch :-)

	Ingo
