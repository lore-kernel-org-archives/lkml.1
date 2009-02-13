Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbZBMUF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbZBMUF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZBMUFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:05:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZBMUFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:05:51 -0500
Date: Fri, 13 Feb 2009 21:05:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: include linux/types.h
Message-ID: <20090213200537.GB27367@elte.hu>
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu> <4995C157.9020102@goop.org> <20090213185500.GA2186@elte.hu> <4995C312.70401@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4995C312.70401@goop.org>
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
>> it is in tip:master, due to:
>>
>>  0fb807c: unconditionally include asm/types.h from linux/types.h
>>  527bdfe: make linux/types.h as assembly safe
>>   
> OK, but that change isn't in x86/headers, so it won't compile standalone.

ok - i merged it into x86/headers.

	Ingo
