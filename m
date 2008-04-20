Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbYDTNf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbYDTNf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 09:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYDTNfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 09:35:15 -0400
Received: from 1wt.eu ([62.212.114.60]:3226 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYDTNfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 09:35:14 -0400
Date: Sun, 20 Apr 2008 15:34:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420133441.GA26536@1wt.eu>
References: <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B3FCF.1090207@firstfloor.org> <20080420133007.GB1899@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420133007.GB1899@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 04:30:07PM +0300, Adrian Bunk wrote:
> Such a "crazy setting" shouldn't be offered to users at all.
> 
> We should either aim at 4k stacks unconditionally for all 32bit 
> architectures with 4k page size or don't allow any architecture
> to offer 4k stacks.

I agree you make a valid point here. Then wouldn't it be easier to
simply remove 4k and agree it was a wet dream ?

Willy

