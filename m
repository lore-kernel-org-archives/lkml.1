Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbZAPM5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbZAPM5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbZAPM5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:57:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51164 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbZAPM5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:57:45 -0500
Date: Fri, 16 Jan 2009 13:57:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Hughes <john@Calva.COM>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: A patch to arch/i386/kernel/irq.c to help get backtraces of
	(near) stack overflow situations
Message-ID: <20090116125731.GG5421@elte.hu>
References: <49707BA9.1040102@Calva.COM> <20090116123844.GB5421@elte.hu> <497081F7.5070007@Calva.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497081F7.5070007@Calva.COM>
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


* John Hughes <john@Calva.COM> wrote:

> Ingo Molnar wrote:
>> in recent kernel's there's an automatic maximum-stack-footprint tracer  
>> plugin available.
>
> Lovely.  Maybe one day I'll be able to use a recent kernel.  :-)

Curious, is that inability of using recent kernls our fault or your fault?
:)

	Ingo
