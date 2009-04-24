Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZDXGnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZDXGnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZDXGnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:43:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57969 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZDXGnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:43:21 -0400
Date: Fri, 24 Apr 2009 08:43:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] HPET: stop soliciting hpet=force users on ICH4M
Message-ID: <20090424064309.GB21739@elte.hu>
References: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain> <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain> <alpine.LFD.2.00.0904231918510.15843@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904231918510.15843@localhost.localdomain>
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


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> The HPET in the ICH4M is not documented in the data sheet
> because it was not officially validated.
> 
> While it is fine for hackers to continue to use "hpet=force"
> to enable the hardware that they have, it is not prudent to
> solicit additional "hpet=force" users on this hardware.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Applied, thanks Len!

	Ingo
