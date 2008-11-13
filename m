Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYKMVeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYKMVeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYKMVdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:33:50 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37011 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbYKMVdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:33:50 -0500
Message-ID: <491C9D39.2020902@us.ibm.com>
Date: Thu, 13 Nov 2008 15:33:45 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "Yeh, Jason" <jason.yeh@amd.com>,
       Robert Richter <robert.richter@amd.com>
CC: Jiri Kosina <jkosina@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>,
       Jiri Benc <jbenc@suse.cz>, Andi Kleen <andi@firstfloor.org>,
       oprofile-list@lists.sf.net, Vilem Marsik <vmarsik@suse.cz>
Subject: Re: Oprofile [still] doesn't work on 2.6.28-rc4 on certain CPU
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu>
In-Reply-To: <20081113212446.GA5694@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jiri Kosina <jkosina@suse.cz> wrote:
> 
>> I haven't yet found a time to start bisecting this.
> 
> Would be nice to identify a commit to revert - in case we run out of 
> time fixing it.
Robert, Jason,
Can one of you take a look at this?  It appears to be an AMD issue right now. 
The first message in the thread can be found at:
http://lkml.org/lkml/2008/11/13/336

Thanks.
-Maynard
> 
> 	Ingo
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list

