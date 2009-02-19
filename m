Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZBSLSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZBSLSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbZBSLSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:18:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33949 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168AbZBSLSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:18:35 -0500
Date: Thu, 19 Feb 2009 12:18:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: x86, vmi: TSC going backwards check in vmi clocksource
Message-ID: <20090219111822.GN2354@elte.hu>
References: <1234989235.7991.2.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234989235.7991.2.camel@alok-dev1>
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


* Alok Kataria <akataria@vmware.com> wrote:

> From: Alok N Kataria <akataria@vmware.com>
> 
> Similar to the check for TSC going backwards in the TSC 
> clocksource, we also need this check for VMI clocksource.

ok. Precisely what kind of bug/symptoms does this fix?

	Ingo
