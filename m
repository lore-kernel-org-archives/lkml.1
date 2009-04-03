Return-Path: <linux-kernel-owner+w=401wt.eu-S936521AbZDCScQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936521AbZDCScQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935061AbZDCSb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:31:58 -0400
Received: from gw.goop.org ([64.81.55.164]:56309 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933940AbZDCSb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:31:57 -0400
Message-ID: <49D65619.8000708@goop.org>
Date: Fri, 03 Apr 2009 11:31:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen for 2.6.30 #2
References: <49D1209A.9000800@goop.org> <49D25A42.7060300@goop.org> <20090331185541.GA17807@elte.hu> <49D2713D.6090401@goop.org> <20090403173623.GB6295@elte.hu>
In-Reply-To: <20090403173623.GB6295@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Yes, but once dom0 goes in your incentive to fix the native kernel 
> performance drain we accumulated along the years of paravirt layers 
> will be strongly weakened, right? :)

Not at all.  There's a pile of performance work that needs to be done, 
both native and Xen.  I've been addressing it in an ad-hoc, time-sliced 
way so far, but I haven't had the chance to concentrate on it as I'd 
like to.  Once I get all the basic stuff off my plate I'll be able to 
actually focus.

Besides, its not really the sort of "incentive" that I respond to; I 
find it demotivating because it carries the presumption that I won't do 
"the right thing" without some element of coercion.  It's not like I 
don't already do a fair amount of generally beneficial kernel work.  If 
you think I should direct my attention in one direction over another, 
I'm happy to take suggestions.

    J
