Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZETHzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZETHzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZETHzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:55:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38029 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbZETHzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:55:07 -0400
Date: Wed, 20 May 2009 09:54:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <teheo@novell.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: JBeulich@novell.com, andi@firstfloor.org,
       linux-kernel-owner@vger.kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
	allocator
Message-ID: <20090520075456.GB23959@elte.hu>
References: <1242305390-21958-1-git-send-email-tj@kernel.org> <4A127F63.8040602@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A127F63.8040602@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <teheo@novell.com> wrote:

> Ingo, Ping.

hpa is handling this - Peter will reply if he has any updates.

	Ingo
