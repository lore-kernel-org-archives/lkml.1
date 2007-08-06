Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbXHFHWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbXHFHWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbXHFHWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:22:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56122 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531AbXHFHV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:21:59 -0400
Date: Mon, 6 Aug 2007 09:21:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 9/9] seqlocks: use PICK_FUNCTION
Message-ID: <20070806072153.GH5359@elte.hu>
References: <20070730024534.369897977@mvista.com> <20070730024721.274774887@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730024721.274774887@mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Replace the old PICK_OP style macros with PICK_FUNCTION. Although, 
> seqlocks has some alien code, which I also replaced as can be seen 
> from the line count below.

ok, i very much like the cleanup effects here, could you resend your 
latest version of this (with Peter's suggested cleanup) against -rc2-rt2 
so that i can apply it?

	Ingo
