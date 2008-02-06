Return-Path: <linux-kernel-owner+w=401wt.eu-S1760619AbYBFVxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619AbYBFVxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYBFVxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:53:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33968 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbYBFVxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:53:14 -0500
Date: Wed, 6 Feb 2008 22:53:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: my config doesnt compile in your tree
Message-ID: <20080206215304.GA13582@elte.hu>
References: <200802061246.43413.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802061246.43413.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> your latest tree. x86/master and x86/mm
> 
>   AS      arch/x86/kernel/entry_64.o
> arch/x86/kernel/entry_64.S: Assembler messages:
> arch/x86/kernel/entry_64.S:618: Error: CFI state restore without previous remember

could you try the latest (freshly updated) x86.git, does it still have 
this problem?

	Ingo
