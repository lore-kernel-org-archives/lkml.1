Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbYEDVkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbYEDVkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYEDVkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:40:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYEDVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:40:44 -0400
Message-ID: <481E2C88.2010702@zytor.com>
Date: Sun, 04 May 2008 14:37:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       jamal <hadi@cyberus.ca>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <1209834123.6972.48.camel@localhost> <20080503173402.GA5292@elte.hu> <alpine.LFD.1.10.0805031936510.6003@apollo.tec.linutronix.de> <alpine.LNX.1.10.0805042326340.11757@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805042326340.11757@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Saturday 2008-05-03 19:39, Thomas Gleixner wrote:
>>> great. So this NOP is indeed not generally known to all "P6 and later" 
>>> CPUs. (the PII)
>> Looks like. My analysis was wrong, as I got the P6 vs. PII/PIII
>> confused :) Damn unintutive numbering, I thought ARM is worse but I'm
>> not so sure anymore.
> 
> Guess that Intel named it Pentium II either because Hexium
> ("5"86:Pentium, "6"86:Hexium) would have been a strange name, or the
> successor to the Pentium/586 was not that great an improvement.
> Or something else? Always kept me wondering.

Yeah, "Hexium" didn't quite work, and they thought they'd already gotten 
a working brand with "Pentium".  That it clashed with their previous 
public prerelease naming scheme of P+number ("P", I believe, for 
"project" or "processor") didn't matter.

The Pentium 4 is properly called the P7, but almost noone calls it that.

"Pentium" is also a highly unstable isotope of hydrogen (Hydrogen-5), 
with a half-life under a zeptosecond.

	-hpa
