Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbYAKL3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbYAKL3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbYAKL24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:28:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbYAKL2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:28:55 -0500
Date: Fri, 11 Jan 2008 12:28:54 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080111112854.GX25945@bingen.suse.de>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110100443.GB28209@elte.hu> <20080110100712.GO25945@bingen.suse.de> <20080110105726.GD28209@elte.hu> <20080110111248.GR25945@bingen.suse.de> <20080111071936.GA16175@elte.hu> <20080111073314.GA24021@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111073314.GA24021@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Write-Combining can be very useful for devices that are behind a slow or 
> a high-latency transport, such as PCI, and which are mapped UnCached 

That is what I wrote! If you meant the same we must have been
spectacularly miscommunicating.

-Andi
