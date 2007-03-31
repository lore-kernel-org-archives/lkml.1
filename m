Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXCaDQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXCaDQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbXCaDQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:16:32 -0400
Received: from gw.goop.org ([64.81.55.164]:41430 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933571AbXCaDQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:16:31 -0400
Message-ID: <460DD28D.2070302@goop.org>
Date: Fri, 30 Mar 2007 20:16:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 0/6] i386 gdt and percpu cleanups
References: <20070331020042.003398870@goop.org>
In-Reply-To: <20070331020042.003398870@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> This is a series of patches based on your latest queue (as of the
> other day, at least).
>   

BTW, the From: line attributions got dropped from a few of these.  These:

    Allow percpu variables to be page-aligned
    Page-align the GDT

should be From: Rusty.  He did most of the work on the others, but I
changed them enough that he shouldn't be saddled with the blame when
things break ;)

    J
