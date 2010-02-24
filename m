Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab0BXUuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:50:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758041Ab0BXUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:50:13 -0500
Date: Wed, 24 Feb 2010 12:50:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Daniel Walker <dwalker@fifo99.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33 released
In-Reply-To: <1267042804.30876.37.camel@c-dwalke-linux.qualcomm.com>
Message-ID: <alpine.LFD.2.00.1002241247130.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002241146140.4513@localhost.localdomain> <1267042804.30876.37.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Feb 2010, Daniel Walker wrote:
> 
> Last merge window you mention you might do a one week merge window this
> time around, are you still planning to do that?

No. But I might do a ten-to-twelve day thing or something like that - just 
to make sure that anybody who tries to game the system and send their 
merge request late will get summarily ignored.

So I'm going to stop being so predictable that people can tell that 
exactly two weeks after the last release is where the merge window closes, 
and if people want to make sure their stuff merged, I had better have a 
merge request in my inbox earlier than thirteen days after the release.

		Linus
