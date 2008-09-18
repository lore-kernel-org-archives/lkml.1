Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYIRSWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYIRSWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbYIRSVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:21:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38914 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbYIRSVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:21:52 -0400
Date: Thu, 18 Sep 2008 20:26:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
Message-ID: <20080918182620.GQ25711@one.firstfloor.org>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com> <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> <878wtxrrwh.fsf@basil.nowhere.org> <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de> <20080914112222.GA3956@ucw.cz> <20080914122618.GD16097@elte.hu> <20080914155928.GB4845@ucw.cz> <20080914160403.GA20082@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914160403.GA20082@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> great! Yinghai, mind reworking the patch in that direction please? I'd 
> suggest to enable the optional dumping of all things BIOS environment 
> related, not just the ACPI/SLIT.

Great. I'm preparing the "kernel iasl -d" patch now @)

-Andi
