Return-Path: <linux-kernel-owner+w=401wt.eu-S1764884AbYD3TO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764884AbYD3TO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762404AbYD3TOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:14:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762300AbYD3TOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:14:09 -0400
Date: Wed, 30 Apr 2008 12:13:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Friesen <cfriesen@nortel.com>
cc: David Newall <davidn@davidnewall.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <4818C336.5000800@nortel.com>
Message-ID: <alpine.LFD.1.10.0804301211510.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <4817EF91.4080800@davidnewall.com> <20080429.211835.130816277.davem@davemloft.net> <48186E57.5070805@davidnewall.com> <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org>
 <4818B8A7.4000902@davidnewall.com> <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org> <4818C336.5000800@nortel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Chris Friesen wrote:
> 
> He did say that he was testing 2.6.25, and that suspend-to-disk was 
> broken in 2.6.25.

Neither of which had anything to do with the whole "slow down" argument.

If you have a bug, make a bug report, and push it, and make people aware 
of it. But don't make it an argument for development to slow down.

Should we all stand around with our thumbs up our *ss because somebody has 
a bug? Should the other developers just stop, because suspend-to-disk is 
broken for somebody? Should everything come to a standstill because David 
Newall doesn't like how there are other things going on that are 
independent of _his_ problems?

Do you really believe that?

			Linus
