Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbXCaDF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbXCaDF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbXCaDF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:05:26 -0400
Received: from gw.goop.org ([64.81.55.164]:49168 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546AbXCaDFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:05:25 -0400
Message-ID: <460DCFF6.2070100@goop.org>
Date: Fri, 30 Mar 2007 20:05:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/6] i386 gdt and percpu cleanups
References: <20070331020042.003398870@goop.org> <1175309761.12230.422.camel@localhost.localdomain>
In-Reply-To: <1175309761.12230.422.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> One nitpick: I'd really like PER_CPU() renamed to PER_CPU_ADDR().
> That's a separate patch, but I think would be far clearer.
>   

Seems pretty simple, given that it has precisely one use.

    J
