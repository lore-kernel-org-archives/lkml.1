Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYGMSOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYGMSOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYGMSOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:14:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbYGMSOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:14:11 -0400
Date: Sun, 13 Jul 2008 20:13:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mgross@linux.intel.com,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: move the descriptions of VT-d to
	Documentations/x86/x86_64/boot-options.txt
Message-ID: <20080713181353.GB18489@elte.hu>
References: <20080707171707V.fujita.tomonori@lab.ntt.co.jp> <20080707065816.29833aca@infradead.org> <20080707232337W.fujita.tomonori@lab.ntt.co.jp> <20080707073110.617c538c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707073110.617c538c@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> > Yeah, seems that only x86 and m64k have the own kernel parameters 
> > file. I think that it would be better to merge them into 
> > Documentation/kernel-parameters.txt.
> 
> I like this alternative; one stop shop is for this information is very 
> valuable

yes. In fact someone might want to think about providing all these 
options during bootup, in a mini session, letting people to choose and 
shape them. (these are the moments where i wish the boot loader was 
integrated into the kernel proper)

	Ingo
