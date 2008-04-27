Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbYD0Ap3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbYD0Ap3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYD0ApT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:45:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48516 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbYD0ApS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:45:18 -0400
Message-ID: <4813CC6A.6030307@zytor.com>
Date: Sat, 26 Apr 2008 17:44:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
References: <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <1208793533.3640.24.camel@localhost.localdomain> <20080421195148.GG8770@elte.hu> <20080421200949.GB2633@cs181133002.pp.htv.fi> <20080421201352.GM8770@elte.hu> <20080421202605.GC2633@cs181133002.pp.htv.fi> <20080421202919.GA28069@elte.hu> <20080421210232.GD2633@cs181133002.pp.htv.fi> <20080421223142.GA18140@elte.hu> <20080426074300.GA3891@ucw.cz>
In-Reply-To: <20080426074300.GA3891@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> I guess Adrian is trying to say:
> 
> 'That code is in tree, so it should compile and run. He can't verify
> it runs, but he's trying to make sure it at least compiles.'
> 
> For 'normal' users it is not a problem.
> 							Pavel

This is fine, except it is an unreasonable request when there are fewer 
existing machines than people contributing to this tree.  For a lot of 
people, compile bandwidth is what is limiting their ability to contribute.

James has offered to fix up Voyager breakage a posteori, and that is the 
appropriate action for a niche architecture like this.

	-hpa
