Return-Path: <linux-kernel-owner+w=401wt.eu-S935508AbYBCMhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935508AbYBCMhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 07:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762826AbYBCMhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 07:37:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51584 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760608AbYBCMg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:36:59 -0500
Date: Sun, 3 Feb 2008 13:36:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: rename module scx200_32 to scx200
Message-ID: <20080203123650.GB18805@elte.hu>
References: <20080203123506.GG20810@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203123506.GG20810@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> The module scx200 were renamed to scx200_32 by the merge of the 32 and 
> 64 bit x86 arch trees.
> 
> Keep the _32 prefix on the .c file as it is 32 bit specific and fix 
> the module name in the Makefile.

thanks Sam for auditing for _32 module renamess - applied.

	Ingo
