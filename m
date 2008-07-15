Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYGOPXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYGOPXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYGOPXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:23:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbYGOPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:23:23 -0400
Date: Tue, 15 Jul 2008 08:22:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Max Krasnyansky <maxk@qualcomm.com>
cc: mingo@elte.hu, dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       pj@sgi.com, ghaskins@novell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and redo
 sched domain managment (take 2)
In-Reply-To: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
Message-ID: <alpine.LFD.1.10.0807150821250.3017@woody.linux-foundation.org>
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Max Krasnyansky wrote:
> 
> I've probably missed something but I'd dare to say consider for the
> inclusion ;-)

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

Thanks for doing the cleanups and the details.

		Linus
