Return-Path: <linux-kernel-owner+w=401wt.eu-S1763705AbXFCAXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763705AbXFCAXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 20:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762969AbXFCAXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 20:23:07 -0400
Received: from khc.piap.pl ([195.187.100.11]:39915 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762915AbXFCAXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 20:23:05 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	<20070602141144.GC5500@stusta.de>
	<20070602104700.53b6b811.akpm@linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 03 Jun 2007 02:23:01 +0200
In-Reply-To: <20070602104700.53b6b811.akpm@linux-foundation.org> (Andrew Morton's message of "Sat, 2 Jun 2007 10:47:00 -0700")
Message-ID: <m3ps4dubru.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> I do that often.  It's useful information.  If person X sends an fbdev
> patch and Tony says "whoa, neat" and I send the patch to Linus then
> Linus could
> well think "wtf, Andrew doesn't know anything about fbdev".  So I do s/whoa
> neat/Acked-by:/ to tell the world that someone who knows something has
> looked at the change.

Makes sense.

> +Acked-by: does not necessarily indicate acknowledgement of the entire patch. 
> +For example, if a patch affects multiple subsystems and has an Acked-by: from
> +one subsystem maintainer then this usually indicates acknowledgement of just
> +the part which affects that maintainer's code.

I'd add, just to be explicit, that acked-by does not necessarily mean
the acker is a maintainer of any subsystem the patch touches, or
generally maintainer of any code.

Unless it isn't true, of course, i.e., unless we really want to limit
expressing non-maintainers opinion in form of ack and nak.
-- 
Krzysztof Halasa
