Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYECTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYECTZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYECTY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:24:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYECTY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:24:59 -0400
Message-ID: <481CBBF2.4090501@zytor.com>
Date: Sat, 03 May 2008 12:24:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Mikael Pettersson <mikpe@it.uu.se>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com> <alpine.LFD.1.10.0805032017290.6003@apollo.tec.linutronix.de> <18460.46554.826031.184323@harpo.it.uu.se> <481CB82D.60404@zytor.com> <alpine.LFD.1.10.0805032115330.6003@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805032115330.6003@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> 
> This might also be caused by a calibration error. We've seen enough of
> them already.
> 

No doubt.  However, there is *something* ugly going on.

	-hpa
