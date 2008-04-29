Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbYD2GzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbYD2GzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYD2GzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:55:14 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54379 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754850AbYD2GzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:55:12 -0400
Date: Tue, 29 Apr 2008 02:55:06 -0400 (EDT)
From: Jeff Arnold <jbarnold@MIT.EDU>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: A system for rebootless kernel security updates
In-Reply-To: <4815A721.1040101@firstfloor.org>
Message-ID: <alpine.DEB.1.10.0804281907150.28653@vinegar-pot.mit.edu>
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu> <87r6cvgyi1.fsf@basil.nowhere.org> <alpine.DEB.1.10.0804280119001.9237@vinegar-pot.mit.edu> <4815A721.1040101@firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only sane way to make such extensions a generically usable linux 
> feature is to merge them to mainline.

> Really it's far better to just merge if you want it to make it out of 
> the "toy" stage.

You're probably right.

I'm willing to undertake the project of bringing the code up to kernel 
coding standards so that it can eventually be considered for mainline. 
I'll plan on undertaking this project if I don't receive feedback that I 
shouldn't do so.

If people have concerns about the high-level design of the system, it 
would be useful for me to know that information sooner rather than later.

If there's anything that I can do to facilitate feedback at this stage, 
please let me know.

Thanks for the advice.

Jeff Arnold
jbarnold@mit.edu
