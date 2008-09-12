Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbYILVpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbYILVpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbYILVpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:45:13 -0400
Received: from doppler.zen.co.uk ([212.23.3.27]:42552 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089AbYILVpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:45:11 -0400
Subject: Re: [PATCH] apci: dump slit
From: Matt Keenan <tank.en.mate@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080912213053.GR7714@one.firstfloor.org>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080912122031.eca8723e.akpm@linux-foundation.org>
	 <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com>
	 <878wtxrrwh.fsf@basil.nowhere.org>
	 <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de>
	 <20080912213053.GR7714@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 22:41:56 +0100
Message-Id: <1221255716.11711.42.camel@bazbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-12 at 23:30 +0200, Andi Kleen wrote:
> > 1.) what guarantees that we reach user space ?
> 
> Broken SLITs don't prevent booting.
> 
> > 2) If it is _valuable_ information which we can gather via kernel
> >    output, then it is much more conveniant than asking the user to type
> >    whatevercryptictoolcommandline and provide the output.
> 
> Yes excellent point.  Should we dump the complete ACPI tables?
> Do you prefer hexdump or do we need a ASL disassembler?
> Also complete SMBIOS? Also the legacy mptables of course too.
> And all the EFI methods.  Ideally a disassembly of the complete BIOS.
> Did I miss anything?
> 

Harsh... but harsh.

Matt


