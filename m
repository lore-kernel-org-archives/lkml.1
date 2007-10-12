Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbXJLV73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbXJLV73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbXJLV7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:59:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758534AbXJLV7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:59:20 -0400
Date: Fri, 12 Oct 2007 14:58:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: arch merge fallout.
In-Reply-To: <20071012182504.GA9222@redhat.com>
Message-ID: <alpine.LFD.0.999.0710121457230.6887@woody.linux-foundation.org>
References: <20071012035743.GA12897@redhat.com>
 <alpine.LFD.0.999.0710112103240.6887@woody.linux-foundation.org>
 <20071012182504.GA9222@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Oct 2007, Dave Jones wrote:
> 
> The git on master.kernel.org (1.5.3.4) is pretty recent, so I don't think
> that's the problem, is it?

It may be that the "renamelimit" thing didn't go into the stable branch at 
all. If you build your git from the current HEAD, it should work.

Or just point me to the thing, and I'll see if I can merge it.

		Linus
