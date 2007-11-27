Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbXK0CCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbXK0CCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbXK0CB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:01:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbXK0CB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:01:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] x86 vDSO: arch/x86/vdso/vdso32
In-Reply-To: Linus Torvalds's message of  Monday, 26 November 2007 17:53:46 -0800 <alpine.LFD.0.9999.0711261745160.5869@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
	<20071119220425.6002E26F8BE@magilla.localdomain>
	<alpine.LFD.0.9999.0711201402520.25057@localhost.localdomain>
	<20071120205759.3533A26F8BE@magilla.localdomain>
	<alpine.LFD.0.9999.0711202348470.25057@localhost.localdomain>
	<20071120232715.0803426F8BE@magilla.localdomain>
	<alpine.LFD.0.9999.0711261745160.5869@woody.linux-foundation.org>
X-Shopping-List: (1) Cautious casinos
   (2) Demonic argumentation ambition
   (3) Pendulous annoyers
   (4) Geopolitical departure shoes
   (5) Aquatic immunization ladders
Message-Id: <20071127020152.169EE26F8C5@magilla.localdomain>
Date: Mon, 26 Nov 2007 18:01:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But whatever works. I'm currently skipping the patches since they didn't 
> seem like 2.6.24 fodder anyway.

The vdso cleanups are pure cleanup, not fixing anything that's actively broken.


Thanks,
Roland
