Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYFBL0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYFBL0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYFBL0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:26:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40309 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYFBL0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:26:41 -0400
Date: Mon, 2 Jun 2008 13:26:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH 0 of 3] xen: save/restore bugfixes
Message-ID: <20080602112611.GE18586@elte.hu>
References: <patchbomb.1212193981@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1212193981@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> Here's some bugfix patches for Xen save/restore.

applied to tip/x86/xen. Thanks,

	Ingo
