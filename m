Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYDSTK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYDSTK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 15:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYDSTKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 15:10:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34240 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbYDSTKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 15:10:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <480A438F.20000@s5r6.in-berlin.de>
Date: Sat, 19 Apr 2008 21:10:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>,
       Shawn Bohrer <shawn.bohrer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080419110034.34b70bd5@laptopd505.fenrus.org> <20080419183302.GA27463@elte.hu>
In-Reply-To: <20080419183302.GA27463@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> and lets observe it that 8K stacks are of course still offered, so if 
> anyone disables 4K stacks in the .config, it will stay disabled.

While you change the default, maybe move it also from the "Kernel 
hacking" menu into the "General setup" menu?  An option with default=y 
is probably not an option that is targeted towards kernel hackers only.
-- 
Stefan Richter
-=====-==--- -=-- =--==
http://arcgraph.de/sr/
