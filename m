Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbZEVTzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbZEVTzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZEVTzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:55:04 -0400
Received: from www.tglx.de ([62.245.132.106]:35249 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZEVTzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:55:03 -0400
Date: Fri, 22 May 2009 21:54:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep
 formorethan2.15 seconds
In-Reply-To: <1243020192.7480.9.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905222153550.3570@localhost.localdomain>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>  <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>  <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>  <1241744048.7518.132.camel@localhost.localdomain>
 <4A04584E.4020307@ti.com>  <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>  <1242172727.3462.55.camel@localhost>  <4A0AE3E3.5090304@ti.com>  <1242232872.9110.98.camel@jstultz-laptop>  <4A0B0939.5030008@ti.com> 
 <1242242497.9777.2.camel@jstultz-laptop>  <4A0D99E0.3050306@ti.com>  <1242436726.29511.198.camel@jstultz-laptop>  <4A16ED34.9060808@ti.com> <1243020192.7480.9.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, john stultz wrote:
> Acked-by: John Stultz <johnstul@us.ibm.com>
> 
> This looks great to me!
> 
> Thanks for putting up with my nit-picky review and revised suggestions!
> 
> Thomas, you ok to pick this up?

Yup, will do.

Thanks,

	tglx
