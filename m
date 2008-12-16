Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYLPKZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYLPKZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYLPKZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:25:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43458 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYLPKZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:25:35 -0500
Date: Tue, 16 Dec 2008 11:25:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [mmotm][PATCH] proc: enclose desc variable of show_stat() in
	CONFIG_SPARSE_IRQ
Message-ID: <20081216102520.GA1539@elte.hu>
References: <20081216165758.DBB2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081216002247.100bc362.akpm@linux-foundation.org> <20081216172455.DBBB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216172455.DBBB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > This would be better, no?
> 
> Agreed. sorry sending silly patch.

it wasnt silly - i've applied Andrew's tweaked variant of your fix to 
tip/irq/sparseirq, thanks guys!

	Ingo
