Return-Path: <linux-kernel-owner+w=401wt.eu-S933941AbXDBGsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbXDBGsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933947AbXDBGsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:48:46 -0400
Received: from gw.goop.org ([64.81.55.164]:59983 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933941AbXDBGsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:48:45 -0400
Message-ID: <4610A73F.4030807@goop.org>
Date: Sun, 01 Apr 2007 23:48:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable
 entries
References: <20070402055652.610711908@goop.org> <20070402055704.278590661@goop.org> <200704020812.18320.ak@suse.de>
In-Reply-To: <200704020812.18320.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> What do the benchmarks say with CONFIG_PARAVIRT on native hardware
> compared to !CONFIG_PARAVIRT. e.g. does lmbench suffer? 
>   

I haven't measured it, but I'll do some experiments.

    J
