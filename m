Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbZBMSCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbZBMSCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZBMSCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:02:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZBMSCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:02:37 -0500
Date: Fri, 13 Feb 2009 19:02:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: remove duplicate pud_large() definition
Message-ID: <20090213180219.GB18581@elte.hu>
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <49959F66.5090100@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49959F66.5090100@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>>         arch/x86/mach-voyager/voyager_smp.c
>>         arch/x86/mm/fault.c
>>   
>
> I'm not sure where these two came from.  I certainly didn't touch those  
> files; they must have diverged somewhere else along their history.

yep, it's drive-by conflicts. Not particularly interesting either as
those files are dead right now.

	Ingo
