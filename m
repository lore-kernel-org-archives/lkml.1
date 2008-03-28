Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYC1JIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYC1JIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbYC1JIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:08:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbYC1JH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:07:59 -0400
Date: Fri, 28 Mar 2008 10:07:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de
Subject: Re: [PATCH 0/9] integrate smp.h
Message-ID: <20080328090739.GG21413@elte.hu>
References: <12066375644061-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber Costa <gcosta@redhat.com> wrote:

> Hi,
> 
> here's the last series I was owing.
> 
> After that, smp_32.h and smp_64.h are gone, merged into smp.h
>  
> as usual, compiled tested in ~ 8 randconfigs for each architecture, 
> and boot tested in all my hardware.

thanks, applied - lets see how it goes.

>  9 files changed, 104 insertions(+), 179 deletions(-)

neat!

	Ingo
