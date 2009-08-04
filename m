Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZHDM3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZHDM3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZHDM3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:29:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36933 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbZHDM3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:29:12 -0400
Date: Tue, 4 Aug 2009 14:28:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Rosenboom <jens@mcbone.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: early_ioremap messages with old ASUS board
Message-ID: <20090804122859.GD4367@elte.hu>
References: <1248351634.7237.32.camel@fnki-nb00130> <86802c440907230739ufe30b4cocc4b16faacc009c4@mail.gmail.com> <1248773808.6757.4.camel@fnki-nb00130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248773808.6757.4.camel@fnki-nb00130>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1022]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Rosenboom <jens@mcbone.net> wrote:

> On Thu, 2009-07-23 at 07:39 -0700, Yinghai Lu wrote:
> > please try attached ...
> 
> No more leak messages when booting with this patch.

Yinghai, please submit the patch to the right people if you have not 
done so yet.

	Ingo
