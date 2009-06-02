Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZFBR2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZFBR2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZFBR2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:28:38 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:43489 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbZFBR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:28:38 -0400
Message-ID: <4A256132.90802@nortel.com>
Date: Tue, 02 Jun 2009 11:28:18 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: George Dunlap <george.dunlap@eu.citrix.com>
CC: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       "jeremy@goop.org" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A25564A.70608@eu.citrix.com>
In-Reply-To: <4A25564A.70608@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2009 17:28:25.0740 (UTC) FILETIME=[892F6CC0:01C9E3A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Dunlap wrote:
> Thomas Gleixner wrote:

> No one disputes the idea that changes shouldn't be ugly; no one disputes 
> the idea that changes shouldn't introduce performance regressions.  But 
> there are patchqueues that are ready, signed-off by other maintainers, 
> and which Ingo admits that he has no technical objections to, but 
> refuses to merge.

I can't comment on this part, but if so that seems unfortunate.

> The main point of Jeremy's e-mail was NOT to say, "Lots of people use 
> this so you should merge it."  He's was responding to Xen being treated 
> like it had no benefit.  It does have a benefit; it is a feature.

I don't know about others, but I certainly interpreted a number of posts
saying exactly that--that it's useful so it should be included.

I don't think anyone is arguing that Xen is not useful or that it should
not ever be included, rather the question is whether the current set of
patches is suitable for addition or whether they are too messy and
should be cleaned up first.

Chris
