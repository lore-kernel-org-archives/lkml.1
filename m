Return-Path: <linux-kernel-owner+w=401wt.eu-S1761900AbXFAPWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761900AbXFAPWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbXFAPWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:22:47 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758842AbXFAPWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:22:47 -0400
Date: Fri, 1 Jun 2007 08:22:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL][RESEND] KVM cpu hotplug fixes
In-Reply-To: <465FB8AA.6050504@qumranet.com>
Message-ID: <alpine.LFD.0.98.0706010819050.3957@woody.linux-foundation.org>
References: <465FB8AA.6050504@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Avi Kivity wrote:
> 
> Please pull from the repository and branch

No. Not after -rc1. Not for something that changes core code and isn't a 
core feature, and wasn't a regression.

> The core issue is that we need a notification [...]

No. The core issue here is that people need to understand that if you miss 
the merge window, and it's new development, YOU DAMN WELL WAIT FOR THE 
NEXT ONE.

Don't send me pull requests like this. And absolutely do NOT send them as 
resends. I just  get grumpy.

If all the added code had been KVM-only, I might not care. But when the 
bulk of the code touches core files, you had better explain why this is so 
important that it cannot wait for the next merge window. 

			Linus
