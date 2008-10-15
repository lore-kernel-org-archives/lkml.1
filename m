Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYJOQU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYJOQU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYJOQUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:20:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYJOQUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:20:21 -0400
Date: Wed, 15 Oct 2008 18:19:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: linux 2.6.27 kernel panic on x86 - please revert commit
	3a85e770aa77e4f1a4096275c97b64c10cd7323e
Message-ID: <20081015161940.GA16568@elte.hu>
References: <Pine.LNX.4.64.0810151902510.19590@boston.corp.fedex.com> <20081015112324.GB31476@elte.hu> <b6a2187b0810150502m3b363b90q106102578e92811d@mail.gmail.com> <20081015120558.GA23347@elte.hu> <b6a2187b0810150639j37ed3be6v3c800fb7d3a4a1f0@mail.gmail.com> <20081015144626.GC7829@linux-os.sc.intel.com> <b6a2187b0810150856qa283c88oc2958c485b718b8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0810150856qa283c88oc2958c485b718b8c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Wed, Oct 15, 2008 at 10:46 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> 
> > Jeff, Does the appended patch fix the issue? Thanks.
> 
> Yes, it does.

applied to tip/x86/urgent, thanks guys!

	Ingo
