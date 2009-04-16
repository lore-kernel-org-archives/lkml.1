Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZDPLDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZDPLDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZDPLCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:02:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZDPLCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:02:51 -0400
Date: Thu, 16 Apr 2009 07:00:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       hpa@zytor.com, tglx@linutronix.de, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416110047.GA10487@infradead.org>
References: <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain> <20090415.164936.138481210.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415.164936.138481210.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 04:49:36PM -0700, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 15 Apr 2009 14:15:45 -0700 (PDT)
> 
> > Instead of havign that IDIOTIC "Impact:" marker, why not just write good 
> > commit messages?
> 
> Amen.

Yeah, please write proper commit messages.  Just make sure the first
sentence mentiones what's fixed/cleaned up/added/generalized and then go
into the details later.  Often enough it might be more than one of
those..

