Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbYECTJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbYECTJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYECTI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:08:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYECTI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:08:56 -0400
Message-ID: <481CB82D.60404@zytor.com>
Date: Sat, 03 May 2008 12:08:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Thomas Gleixner <tglx@linutronix.de>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost>	<alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>	<481CA40A.7040906@zytor.com>	<alpine.LFD.1.10.0805032017290.6003@apollo.tec.linutronix.de> <18460.46554.826031.184323@harpo.it.uu.se>
In-Reply-To: <18460.46554.826031.184323@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
> I also noticed that jamal's /proc/cpuinfo contains
>> cpu MHz         : 1063.771
> which is either wrong or indicates serious overclocking.
> The PIIs maxed out at about 400/450MHz.
> 

It's worse than that... it's claiming to be a *Klamath*, which topped 
out at 300 MHz.

	-hpa
