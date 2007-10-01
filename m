Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXJAR45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXJAR45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbXJAR4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:56:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbXJAR4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:56:49 -0400
Message-ID: <470134CC.3080100@redhat.com>
Date: Mon, 01 Oct 2007 13:56:28 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: x86_64 and AMD with C1E
References: <20071001101532.025d652f@localhost> <p73r6kf6uwz.fsf@bingen.suse.de> <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com> <b70f2f960710010550i30ae48bu31f137fe46d70611@mail.gmail.com> <alpine.LRH.0.999.0710011612001.7353@www.tglx.de> <20071001143225.GA19797@one.firstfloor.org> <alpine.LRH.0.999.0710011652470.7353@www.tglx.de> <20071001152153.GB19797@one.firstfloor.org>
In-Reply-To: <20071001152153.GB19797@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2007 11:21 AM, Andi Kleen wrote:
> 
> Also I'm not sure but I suspect non Intel HPETs have less than
> three timers. Certainly they generally miss the 64bitness.
> 

nVidia C51/MCP51 chipset, AMD Turion X2:

hpet0: 3 32-bit timers, 25000000 Hz

