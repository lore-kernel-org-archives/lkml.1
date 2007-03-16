Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbXCPL2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbXCPL2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXCPL2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:28:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbXCPL2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:28:43 -0400
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] i386: Simplify smp_call_function*() by using common implementation
Date: Fri, 16 Mar 2007 12:26:24 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, eranian@hpl.hp.com, rdunlap@xenotime.net,
       Jan Beulich <jbeulich@novell.com>
References: <45F5FA97.8070705@goop.org> <20070315110805.262e1fa3.akpm@linux-foundation.org> <45F9D5DD.8040909@goop.org>
In-Reply-To: <45F9D5DD.8040909@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161226.25079.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> [ Jan, Andi: This only changes arch/i386; can x86_64 be changed in the
>   same way? ]
>
> [ Rebased onto Jan's x86_64-mm-consolidate-smp_send_stop patch ]

I already got the earlier patch of yours, but not Jan's patch :/
I'll sort it out.

-Andi
