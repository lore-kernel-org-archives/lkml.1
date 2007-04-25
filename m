Return-Path: <linux-kernel-owner+w=401wt.eu-S2992792AbXDYQB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992792AbXDYQB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992793AbXDYQBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:01:55 -0400
Received: from [70.254.190.220] ([70.254.190.220]:50687 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992790AbXDYQBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:01:54 -0400
Date: Wed, 25 Apr 2007 16:01:52 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: Reasons to merge suspend2.
In-Reply-To: <alpine.DEB.0.98.0704251111000.18512@sigma.j-a-k-j.com>
Message-ID: <Pine.LNX.4.64.0704251600030.25153@server.thyself>
References: <200704251551.38373.a1426z@gawab.com>
 <alpine.DEB.0.98.0704251111000.18512@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, John Anthony Kazos Jr. wrote:

>> I didn't read your whole post, it's way too long, but I would like to see
>> your patch in mainline as an option to swsusp.  What would make this
>> infeasible?
>
> For one thing, Linus said not but yesterday that he doesn't want multiple
> competing suspend algorithms like this in the kernel at once. (If I parsed
> his message correctly, he doesn't want any in the kernel, but he's putting
> up with it because it seems somewhat needed.)

Would it be a feasible solution to have a very minimal and generic software 
suspend in the kernel, and then various userspace implementations could take 
care of this? Or is all of the software suspend code in the kernel absolutely 
necessary, such that this wouldn't work?

William Heimbigner
icxcnika@mar.tar.cc
