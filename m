Return-Path: <linux-kernel-owner+w=401wt.eu-S1763952AbYBUJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763952AbYBUJiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762670AbYBUJiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:38:00 -0500
Received: from styx.suse.cz ([82.119.242.94]:58706 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757000AbYBUJh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:37:59 -0500
Date: Thu, 21 Feb 2008 10:37:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: elendil@planet.nl, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
In-Reply-To: <1203221372.6124.29.camel@popeye>
Message-ID: <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz>
References: <1203123219.6176.36.camel@popeye>  <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
  <1203163503.6124.5.camel@popeye>  <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz>
 <1203221372.6124.29.camel@popeye>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Chris Holvenstot wrote:

> This is just to confirm that I have been running all day on a kernel 
> built with CONFIG_GROUP_SCHED turned 'off' and have not seen the problem 
> with my keyboard (I never noticed a problem with the mouse as others 
> have)

Chris,

does the keyboard malfunction with CONFIG_GROUP_SCHED only when you are 
running in X, or does that happen also on console?

-- 
Jiri Kosina
SUSE Labs
