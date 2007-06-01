Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbXFAQcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbXFAQcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760153AbXFAQcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:32:12 -0400
Received: from il.qumranet.com ([82.166.9.18]:38548 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760597AbXFAQcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:32:08 -0400
Message-ID: <46604A05.6060507@qumranet.com>
Date: Fri, 01 Jun 2007 19:32:05 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL][RESEND] KVM cpu hotplug fixes
References: <465FB8AA.6050504@qumranet.com> <alpine.LFD.0.98.0706010819050.3957@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706010819050.3957@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 01 Jun 2007 19:32:06 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Don't send me pull requests like this. And absolutely do NOT send them as 
> resends. I just  get grumpy.
>
> If all the added code had been KVM-only, I might not care. But when the 
> bulk of the code touches core files, you had better explain why this is so 
> important that it cannot wait for the next merge window. 	

Ok.  This was really wanted by laptop-carrying users, but I guess
they'll have to wait for 2.6.23.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

