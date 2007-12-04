Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbXLDV2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbXLDV2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXLDV2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:28:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40165 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbXLDV23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:28:29 -0500
Date: Tue, 4 Dec 2007 22:28:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christian Kujau <christian@g-house.de>
Cc: Len Brown <lenb@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
Message-ID: <20071204212805.GB10360@elte.hu>
References: <200711280121.18376.lenb@kernel.org> <20071204122649.GB27286@elte.hu> <alpine.DEB.0.99999.0712042152070.9287@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99999.0712042152070.9287@sheep.housecafe.de>
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


* Christian Kujau <christian@g-house.de> wrote:

> On Tue, 4 Dec 2007, Ingo Molnar wrote:
>> thanks for the patch and the extensive description. I've applied this to
>> x86.git. Do you agree that this has no urgency for v2.6.24 and is thus
>> v2.6.25 material?
>
> Pardon my ignorance, but: aren't we in -rc already? I was under the 
> assumption that during the -rc phase only (release-)critical bugfixes 
> would be applied? So this one *must* be 2.6.25 material, right?

that was just a boilerplate question from me to make sure there's no 
misunderstanding about where it got queued and what the planned timeline 
is.

	Ingo
