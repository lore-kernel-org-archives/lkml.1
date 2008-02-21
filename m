Return-Path: <linux-kernel-owner+w=401wt.eu-S1765604AbYBUJur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765604AbYBUJur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765339AbYBUJug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:50:36 -0500
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:59700
	"EHLO QMTA06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765333AbYBUJuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:50:35 -0500
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 04:50:34 EST
X-Authority-Analysis: v=1.0 c=1 a=TEGKNp2qDdgA:10 a=Al2GMUxp3q319iOwV-4A:9
 a=oNzJz-ubopelTF3YAn3mopJLPBgA:4 a=uv1ck3d6JtEA:10
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: elendil@planet.nl, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz>
References: <1203123219.6176.36.camel@popeye>
	 <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
	 <1203163503.6124.5.camel@popeye>
	 <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz>
	 <1203221372.6124.29.camel@popeye>
	 <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 03:45:00 -0600
Message-Id: <1203587101.27355.4.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri - 

I am tempted to lie to you and say it was in both modes, or when running
under X only, but to tell you the truth while I have not seen it while
running in console mode, I have not spent enough time there to make a
solid statement one way or the other.

Sorry

Chris





On Thu, 2008-02-21 at 10:37 +0100, Jiri Kosina wrote:
> On Sat, 16 Feb 2008, Chris Holvenstot wrote:
> 
> > This is just to confirm that I have been running all day on a kernel 
> > built with CONFIG_GROUP_SCHED turned 'off' and have not seen the problem 
> > with my keyboard (I never noticed a problem with the mouse as others 
> > have)
> 
> Chris,
> 
> does the keyboard malfunction with CONFIG_GROUP_SCHED only when you are 
> running in X, or does that happen also on console?
> 

