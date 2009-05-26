Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZEZU0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZEZU0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZEZU0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:26:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51192 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZEZU0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:26:38 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep
 formorethan2.15 seconds
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A1C06D7.8080000@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>
	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>
	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>
	 <1242172727.3462.55.camel@localhost>  <4A0AE3E3.5090304@ti.com>
	 <1242232872.9110.98.camel@jstultz-laptop>  <4A0B0939.5030008@ti.com>
	 <1242242497.9777.2.camel@jstultz-laptop>  <4A0D99E0.3050306@ti.com>
	 <1242436726.29511.198.camel@jstultz-laptop>  <4A16ED34.9060808@ti.com>
	 <1243020192.7480.9.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0905222153550.3570@localhost.localdomain>
	 <4A1C06D7.8080000@ti.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 13:26:37 -0700
Message-Id: <1243369597.3275.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 10:12 -0500, Jon Hunter wrote:
> Thomas Gleixner wrote:
> > On Fri, 22 May 2009, john stultz wrote:
> >> Acked-by: John Stultz <johnstul@us.ibm.com>
> >>
> >> This looks great to me!
> >>
> >> Thanks for putting up with my nit-picky review and revised suggestions!
> >>
> >> Thomas, you ok to pick this up?
> > 
> > Yup, will do.
> 
> Hi Thomas, John,
> 
> Would you also be willing to accept the initial patch that I submitted?
> 
> See: http://marc.info/?l=linux-kernel&m=124026224019895&w=2
> 
> If so, I could resubmit the two patches as a patch series called 
> something like "dynamic tick: enabling longer sleep times on 32-bit 
> machines."
> 
> Let me know your thoughts. I will also also add a changelog too.

Yea, I think both of them look good. So I'd resend as a patch set with
proper patch descriptions on both.

thanks
-john


