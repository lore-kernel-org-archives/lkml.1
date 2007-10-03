Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXJCTIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXJCTIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbXJCTHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:07:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40803 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbXJCTHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:07:54 -0400
Message-ID: <4703E888.9010803@garzik.org>
Date: Wed, 03 Oct 2007 15:07:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Doing it as early as possible in the 2.6.24-rc4 series (basically I'll do 
> it first thing) will mean that we'll have the maximum amount of time to 
> sort out any issues, and the thing is, Thomas and Ingo already have a tree 
> ready to go, so people can check their work against that, and don't need 
> to think that they have to do any fixups after it his *my* tree. It would 
> be much better if everybody was just ready for it, and not taken by 
> surprise.

I'm a bit confused...  you typed 2.6.24-rc4; I'm guessing you meant 
2.6.24-rc1, but did you mean

	"x86 merge as soon as 2.6.23 is released" (merge window opens)

or

	"x86 merge as soon as 2.6.24-rc1 is released"

?

Thanks,

	Jeff


