Return-Path: <linux-kernel-owner+w=401wt.eu-S2993078AbXCIIjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993078AbXCIIjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993083AbXCIIjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:39:23 -0500
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:51908 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993078AbXCIIjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:39:22 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Fri, 9 Mar 2007 19:39:05 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <20070309075358.GA10394@waste.org> <20070309082057.GB10394@waste.org>
In-Reply-To: <20070309082057.GB10394@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091939.05535.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 19:20, Matt Mackall wrote:
> And I've just rebooted with NO_HZ and things are greatly improved. At
> idle, Beryl effects are silky smooth (possibly better than stock) and
> shows less load. Under 'make', Beryl is still responsive as is Galeon.
> No sign of lagging mouse or typing.
>
> Under make -j 5, things are intermittent. Galeon scrolling is
> sometimes still responsive, but Beryl, terminals and mouse still drag
> quite a bit.

I just replied before you sent this one out I think our messages passed each 
other across the ocean somewhere. I don't quite get what combination of 
factors you're saying here caused great improvement. Was it enabling NO_HZ on 
mainline cpu scheduler or disabling NO_HZ or on RSDL?

-- 
-ck
