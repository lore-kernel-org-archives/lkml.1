Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYFXLny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYFXLny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYFXLnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:43:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46246 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYFXLnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:43:46 -0400
Date: Tue, 24 Jun 2008 13:43:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lockdep: remove duplicate definition of
	STATIC_LOCKDEP_MAP_INIT
Message-ID: <20080624114330.GD21890@elte.hu>
References: <485F0FFA.20900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485F0FFA.20900@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0093]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> STATIC_LOCKDEP_MAP_INIT is defined twice in lockdep.h. I guess it's a 
> copy & paste.

applied to tip/core/locking, thanks!

	Ingo
