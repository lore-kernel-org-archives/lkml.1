Return-Path: <linux-kernel-owner+w=401wt.eu-S935946AbYEWHJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935946AbYEWHJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935588AbYEWHJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:09:28 -0400
Received: from www.tglx.de ([62.245.132.106]:56421 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935534AbYEWHJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:09:27 -0400
Date: Fri, 23 May 2008 09:09:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: move mp_bus_not_pci from mpparse.c
In-Reply-To: <4835EF80.7080901@suse.de>
Message-ID: <alpine.LFD.1.10.0805230907230.3295@apollo.tec.linutronix.de>
References: <20080519154656.15071.96979.stgit@thinkpad> <20080519154715.15071.44328.stgit@thinkpad> <alpine.LFD.1.10.0805222351400.3295@apollo.tec.linutronix.de> <4835EF80.7080901@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008, Alexey Starikovskiy wrote:
> 
> Do you still claim io_apic has no association with mp_bus_not_pci?

No, I was wrong as usual. :) I'd still prefer not to add stuff twice,
but unifying io_apic is a tough one.

Thanks,
	tglx
