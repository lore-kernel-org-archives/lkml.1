Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbXLEKZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbXLEKZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbXLEKZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:25:19 -0500
Received: from www.tglx.de ([62.245.132.106]:44395 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbXLEKZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:25:17 -0500
Date: Wed, 5 Dec 2007 11:25:00 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Nick Piggin <npiggin@suse.de>
Cc: akpm@linux-foundation.org, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/18] uio: nopage
Message-ID: <20071205112500.2c97035f@dilbert.local>
In-Reply-To: <20071205101042.GC1114@wotan.suse.de>
References: <20071205071547.701344000@nick.local0.net>
	<20071205071627.143603000@nick.local0.net>
	<20071205110408.3eab9340@dilbert.local>
	<20071205101042.GC1114@wotan.suse.de>
Organization: Linutronix
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 5 Dec 2007 11:10:42 +0100
schrieb Nick Piggin <npiggin@suse.de>:

> On Wed, Dec 05, 2007 at 11:04:08AM +0100, Hans-Jürgen Koch wrote:
> > Am Wed, 05 Dec 2007 18:15:51 +1100
> > schrieb npiggin@suse.de:
> > 
> > > Convert uio from nopage to fault.
> > > 
> > > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > > Cc: greg@kroah.com
> > 
> > Hi Nick,
> > could you please add me to Cc: for UIO stuff:
> > 
> > Cc: hjk@linutronix.de
> 
> Sure, I'll try to remember in future. It would be helpful if you could
> add an entry to MAINTAINERS?

Well, although I wrote a lot of UIO code and feel a bit responsible for
it, I don't know if I can call myself an UIO maintainer. ATM, I think
it's considered "driver core" and is therefore in Greg's domain.

Thanks,
Hans

> 
> > 
> > The patch itself looks alright to me, but I didn't test with a real
> > driver.
> > 
> > Acked-by: Hans J Koch <hjk@linutronix.de>
> 
> Thanks,
> Nick
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
