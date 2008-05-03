Return-Path: <linux-kernel-owner+w=401wt.eu-S933246AbYECSTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246AbYECSTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760208AbYECSTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:19:06 -0400
Received: from www.tglx.de ([62.245.132.106]:35989 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759546AbYECSTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:19:03 -0400
Date: Sat, 3 May 2008 20:18:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: jamal <hadi@cyberus.ca>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
In-Reply-To: <481CA40A.7040906@zytor.com>
Message-ID: <alpine.LFD.1.10.0805032017290.6003@apollo.tec.linutronix.de>
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, H. Peter Anvin wrote:

> Thomas Gleixner wrote:
> > 
> > Jan, are you sure that P3 knows the P6 NOPs ? AFAICT its P4, but I
> > have to dig up the manuals.
> > 
> 
> Pentium III is the P6 core, so it will.
> 
> Intel explicitly documents "all processors with family 6 or F."

Yeah, I looked up myself and noticed that I confused those stupid
numbers again.

Nevertheless reality seems to tell a different story :)

Thanks,

	tglx
