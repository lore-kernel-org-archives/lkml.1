Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYEDVbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYEDVbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYEDVbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:31:03 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37543 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYEDVbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:31:02 -0400
Date: Sun, 4 May 2008 23:31:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
In-Reply-To: <alpine.LFD.1.10.0805031936510.6003@apollo.tec.linutronix.de>
Message-ID: <alpine.LNX.1.10.0805042326340.11757@fbirervta.pbzchgretzou.qr>
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <1209834123.6972.48.camel@localhost> <20080503173402.GA5292@elte.hu> <alpine.LFD.1.10.0805031936510.6003@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-05-03 19:39, Thomas Gleixner wrote:
>> great. So this NOP is indeed not generally known to all "P6 and later" 
>> CPUs. (the PII)
>
>Looks like. My analysis was wrong, as I got the P6 vs. PII/PIII
>confused :) Damn unintutive numbering, I thought ARM is worse but I'm
>not so sure anymore.

Guess that Intel named it Pentium II either because Hexium
("5"86:Pentium, "6"86:Hexium) would have been a strange name, or the
successor to the Pentium/586 was not that great an improvement.
Or something else? Always kept me wondering.
