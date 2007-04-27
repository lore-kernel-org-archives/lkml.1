Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbXD0SBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbXD0SBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbXD0SBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:01:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44091 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198AbXD0SBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:01:38 -0400
Message-ID: <46323A6B.3000909@pobox.com>
Date: Fri, 27 Apr 2007 14:01:15 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Neil Horman <nhorman@tuxdriver.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
References: <463166C2.6060106@bigpond.net.au> <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org> <46319297.905@bigpond.net.au> <20070427122247.GA19017@hmsreliant.homelinux.net> <4632088C.8000509@bigpond.net.au> <20070427171150.GF19017@hmsreliant.homelinux.net> <alpine.LFD.0.98.0704271045180.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271045180.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Jeff, I'm going to assume I get all these through your normal network 
> driver tree.

Yep.

Today, I'm sending you and Andrew fixes like the e1000 stuff just sent, 
and Neil's fixes.  Then after the merging dust settles, I'll push 
jgarzik/netdev-2.6.git#upstream, which is the bulk of the net driver 
stuff queued for 2.6.22.

	Jeff


