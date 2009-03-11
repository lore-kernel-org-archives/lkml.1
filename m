Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZCKIA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZCKIA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZCKIAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:00:48 -0400
Received: from www.tglx.de ([62.245.132.106]:52340 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbZCKIAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:00:47 -0400
Date: Wed, 11 Mar 2009 08:59:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org
Subject: Re: [patch 08/18] powerpc: convert obsolete irq_desc_t to struct
 irq_desc
In-Reply-To: <1236737962.7086.35.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0903110859150.29264@localhost.localdomain>
References: <20090311003204.592133594@linutronix.de>  <20090311003236.263019667@linutronix.de> <1236737962.7086.35.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Benjamin Herrenschmidt wrote:

> On Wed, 2009-03-11 at 00:45 +0000, Thomas Gleixner wrote:
> > plain text document attachment
> > (powerpc-convert-obsolete-irq-desc-t-typedef.patch)
> > Impact: cleanup
> > 
> > Convert the last remaining users.
> 
> Ack. This would be more easily carried in my -next tree if that's ok
> with you.

Sure. Thanks,

		tglx
