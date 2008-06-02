Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYFBJry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYFBJry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYFBJrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:47:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYFBJrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:47:45 -0400
Date: Mon, 2 Jun 2008 11:46:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Stas Sergeev <stsp@aknet.ru>,
       ambx1@neo.rr.com, david-b@pacbell.net, tglx@linutronix.de,
       dbrownell@users.sourceforge.net, rmk+lkml@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch][resend] provide rtc_cmos platform device, take 2
Message-ID: <20080602094647.GA7459@elte.hu>
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org> <483BEF1A.3080808@aknet.ru> <20080528163600.b4c3c12c.akpm@linux-foundation.org> <200805290854.54577.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805290854.54577.bjorn.helgaas@hp.com>
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


* Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> Andrew added these patches to his -mm tree, but I don't think he's 
> released a patchset that contains them yet.  I'll attach the patch in 
> case you want to try it.  Let me know what happens.

added your patch to -tip for more testing, to the tip/out-of-tree topic 
branch. It already passed a fair amount of testing here.

	Ingo
