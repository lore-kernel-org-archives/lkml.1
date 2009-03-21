Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZCUMHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZCUMHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZCUMHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:07:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:37679 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZCUMHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:07:43 -0400
Message-ID: <49C4D88A.9020406@monstr.eu>
Date: Sat, 21 Mar 2009 13:07:38 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       john.williams@petalogix.com
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>  <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>  <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>  <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>  <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>  <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>  <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>  <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain>  <49C2AB09.9040300@monstr.eu>  <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain>  <1237515861.7106.215.camel@jstultz-laptop>  <49C34558.6030006@monstr.eu> <1237581607.7191.51.camel@localhost.localdomain> <49C4C3BD.9090905@monstr.eu> <alpine.LFD.2.00.0903211206090.29264@localhost.localdomain> <49C4D628.7060805@monstr.eu> <alpine.LFD.2.00.0903211303360.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903211303360.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 21 Mar 2009, Michal Simek wrote:
>> Yes, I see it. I think I sent my log in any previous email in this thread too +
>> I see it on my heartbeat led too.
>>
>> Thanks for explanation,
> 
> Welcome. Thanks for working on the review issues. I looked through
> your timer and interrupt code and I'm quite happy with it.
> 
> Please add: Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 
> to both.

I want to fix rating and shift value nothing other.
I'll add it.

Thanks for your help,
Michal

> 
> Thanks,
> 
> 	tglx


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
