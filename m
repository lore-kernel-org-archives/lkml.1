Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYFYVP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYFYVP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYFYVPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:15:48 -0400
Received: from saeurebad.de ([85.214.36.134]:44361 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYFYVPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:15:47 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softlockup: show irqtrace
References: <20080625071323.GA7987@damson.getinternet.no>
Date: Wed, 25 Jun 2008 23:15:23 +0200
In-Reply-To: <20080625071323.GA7987@damson.getinternet.no> (Vegard Nossum's
	message of "Wed, 25 Jun 2008 09:13:23 +0200")
Message-ID: <87prq52p3o.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Vegard Nossum <vegard.nossum@gmail.com> writes:

> Hi,
>
> Ingo, can you please drop the "softirq softlockup debugging" patch and
> apply this instead? This much, much prettier, reuses existing debugging
> infrastructure, and is a lot more generic.
>
> (Compile tested on allyesconfig, allnoconfig, allnoconfig + softlockup
> debugging.)
>
>
> Vegard
>
>
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Wed, 25 Jun 2008 08:50:10 +0200
> Subject: [PATCH] softlockup: show irqtrace
>
> This patch adds some information about when interrupts were last
> enabled and disabled to the output of the softlockup detector.

Nice idea!

> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

  Acked-by: Johannes Weiner <hannes@saeurebad.de>
