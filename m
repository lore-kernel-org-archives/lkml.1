Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0BRJDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:03:50 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:38100 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab0BRJDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:03:47 -0500
Date: Thu, 18 Feb 2010 04:02:39 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       davej@redhat.com, Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
 even when ignore_ppc=0
In-reply-to: <20100216222611.GP29569@tux1.beaverton.ibm.com>
Message-id: <alpine.LFD.2.00.1002180401360.4135@localhost.localdomain>
References: <20090429220037.GA8604@srcf.ucam.org>
 <20090430072556.GD16737@elte.hu> <20090430095414.GA19462@srcf.ucam.org>
 <20090430111042.GA12809@elte.hu> <20090430111338.GA21297@srcf.ucam.org>
 <20090515191219.GH6968@plum> <20090602232108.GG7917@plum>
 <20090607100541.GJ31286@elte.hu> <20090715003207.GA5111@plum>
 <20100216220707.GA5966@srcf.ucam.org>
 <20100216222611.GP29569@tux1.beaverton.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 16, 2010 at 10:07:07PM +0000, Matthew Garrett wrote:
> > Did this ever get picked up?
> 
> Nope.  I vaguely recall asking a few times if there were any objections left,
> but there weren't any, and I think Len or someone said it looked good back at
> LPC last summer.  Does not appear in 2.6.33-rc8 though.

does it have a bugzilla entry? (as regressions tend to, thanks to rafael)
I don't see this in my mailbox anymore.
