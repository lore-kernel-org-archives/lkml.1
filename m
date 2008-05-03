Return-Path: <linux-kernel-owner+w=401wt.eu-S1765675AbYECRnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765675AbYECRnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYECRnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:43:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYECRnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:43:10 -0400
Message-ID: <481CA40A.7040906@zytor.com>
Date: Sat, 03 May 2008 10:42:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: jamal <hadi@cyberus.ca>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> 
> Jan, are you sure that P3 knows the P6 NOPs ? AFAICT its P4, but I
> have to dig up the manuals.
> 

Pentium III is the P6 core, so it will.

Intel explicitly documents "all processors with family 6 or F."

	-hpa
