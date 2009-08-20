Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZHTKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZHTKuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZHTKun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:50:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45574 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZHTKum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:50:42 -0400
Date: Thu, 20 Aug 2009 12:50:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kelly Bowa <kelly.bowa@gmail.com>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Atom processor inclusion
Message-ID: <20090820105029.GF29093@elte.hu>
References: <20090820130648.6e7236f7@titus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820130648.6e7236f7@titus>
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


* Kelly Bowa <kelly.bowa@gmail.com> wrote:

> Hi Ingo,
> 
> Any ideas if the Atom CPU patch mentioned here
> http://groups.google.ca/group/fa.linux.kernel/browse_thread/thread/26d61febdf354055/a0b4c902e41b5fbf?hl=en&ie=UTF-8&q=config_mcore2+atom
> has been submitted/considered for mainline inclusion. AFAIK GCC 4.5
> *should* contain the architecture specific code.

Yep, it looked acceptable - Tobias, do you have any 
updates / latest version of that patch?

	Ingo
