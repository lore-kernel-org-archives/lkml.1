Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZHaTkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZHaTkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZHaTkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:40:18 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:43086 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZHaTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:40:17 -0400
Date: Mon, 31 Aug 2009 21:40:13 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: srostedt@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] tracing: remove mentioning of legacy latency_trace
 file from documentation
Message-ID: <20090831194013.GC4237@pc-ras4041.res.insa>
References: <1251744635-14926-1-git-send-email-albin.tonnerre@free-electrons.com>
 <20090831191937.GD6048@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831191937.GD6048@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 09:19:38PM +0200, Frederic Weisbecker wrote :
> On Mon, Aug 31, 2009 at 08:50:35PM +0200, Albin Tonnerre wrote:
> >  # tracer: irqsoff
> > @@ -382,7 +374,7 @@ The above is mostly meaningful for kernel developers.
> >  
> >    time: This differs from the trace file output. The trace file output
> >  	includes an absolute timestamp. The timestamp used by the
> > -	latency_trace file is relative to the start of the trace.
> > +	trace file is relative to the start of the trace.
> 
> 
> Not only is it wrong, but the sentence is now completely antithetic.

Oops. this wasn't meant to be there. I'll fix that.

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
