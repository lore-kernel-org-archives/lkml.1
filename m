Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYGOP3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYGOP3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbYGOPZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:25:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757362AbYGOPZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:25:14 -0400
Date: Tue, 15 Jul 2008 08:24:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Max Krasnyansky <maxk@qualcomm.com>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, pj@sgi.com, ghaskins@novell.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and redo
 sched domain managment (take 2)
In-Reply-To: <1216123068.27242.60.camel@violet.holtmann.net>
Message-ID: <alpine.LFD.1.10.0807150823340.3017@woody.linux-foundation.org>
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>  <1216122577.27242.57.camel@violet.holtmann.net>  <1216122720.12595.173.camel@twins> <1216123068.27242.60.camel@violet.holtmann.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Marcel Holtmann wrote:
> 
> so it wasn't meant to say "... if cpu ..." and I simply miss something
> here (which is possible)?

Heh. You don't have enough of a math background, it seems. 'iff' is a 
stronger 'if' - it's 'if and only if'.

			Linus
