Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbZE1SiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbZE1SiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbZE1SiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:38:12 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:38798 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbZE1SiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:38:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloJAAd1HkpMQW1W/2dsb2JhbACBT5cPtkSEDQU
Date: Thu, 28 May 2009 14:38:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090528183811.GA26947@Krystal>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal> <20090528182008.GJ20736@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090528182008.GJ20736@n2100.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:37:09 up 89 days, 15:03,  5 users,  load average: 1.24, 0.52,
	0.29
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> On Tue, May 26, 2009 at 11:36:54AM -0400, Mathieu Desnoyers wrote:
> > The rest looks good.
> 
> Good, I've reverted the removal of "memory", and so I guess we're all
> happy with the patch now.

Yes, you can add a

Reported-Reviewed-and-Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

if you feel like it.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
