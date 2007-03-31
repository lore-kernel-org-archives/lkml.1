Return-Path: <linux-kernel-owner+w=401wt.eu-S933286AbXCaBcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbXCaBcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933290AbXCaBcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:32:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:60492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286AbXCaBcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:32:47 -0400
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: exposing FSB clock speed in /sys
References: <20070330153937.GC16059@frankl.hpl.hp.com>
From: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20070330153937.GC16059@frankl.hpl.hp.com>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
Date: 31 Mar 2007 04:31:29 +0200
Message-ID: <p73bqiaqh32.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian-sDzT885Ts8HQT0dZR+AlfA@public.gmane.org> writes:

> It seems that the kernel does not expose the Front-Side Bus (FSN) Clock
> speed to user applications. 

You mean the APIC timer frequency which happens to match the FSB 
on some CPUs? 
 
> Knowledge the the FSB speed is very useful to monitoring tools. It is used
> to compute certain bus-related metrics.

Can you describe those metrics in detail? 

-Andi
