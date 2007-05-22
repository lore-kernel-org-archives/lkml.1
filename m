Return-Path: <linux-kernel-owner+w=401wt.eu-S1763734AbXEVPHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763734AbXEVPHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbXEVPGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:06:55 -0400
Received: from gw.goop.org ([64.81.55.164]:47734 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbXEVPGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:06:54 -0400
Message-ID: <46530708.3040402@goop.org>
Date: Tue, 22 May 2007 16:06:48 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [patch 00/33] xen: Xen paravirt_ops implementation
References: <20070522140941.802382212@goop.org> <200705221657.53607.ak@suse.de>
In-Reply-To: <200705221657.53607.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This is the Xen implementation for the paravirt_ops interface.  The
>> series is based on 2.6.22-rc1-mm1, and I think its ready to be cooked
>> in -mm with a view to being merged in 2.6.23.
>>     
>
> I already got it in my tree now from your previous post. Does this
> version have changes over that one? 

Yes, I've done a few passes of tidying up, and spent some effort on
beefing up the patch descriptions/changelogs.  There are no significant
functional differences though.

    J
