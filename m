Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZDIVgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZDIVgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbZDIVfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:35:55 -0400
Received: from main.gmane.org ([80.91.229.2]:60652 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbZDIVfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:35:54 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kevin Bowling <kevin.bowling@gmail.com>
Subject: Re: [RFC GIT PULL (late)] Xen updates for v2.6.30
Followup-To: gmane.linux.kernel
Date: Thu, 09 Apr 2009 14:35:33 -0700
Message-ID: <grlpna$3sq$1@ger.gmane.org>
References: <20090409181039.GA605@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 155.225.123.210
User-Agent: KNode/0.99.01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> Linus,
> 
> Would you still be willing to pull pending Xen updates? They can be
> pulled from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
>    xen-for-linus
> 
> These are late, delayed past the merge window due to the discussions
> around the DOM0 bits and due to an exceptionally busy merge window.

There are a lot of us that would really like to see Xen dom0 merged 
upstream, and several people were disappointed when it didn't go in the 
2.6.30-rc1 merge window (check that thread).  The biggest concern was "do 
people _want_ Xen merged?" rather than any technical problems with the code.    
I think, without a doubt, yes.  Xen is used by many corporations.  It has 
excellent performance, works across platforms that do not have hardware 
virt, and has a proven track record -- check out companies like Linode.com 
and Slicehost.  It also has the maintainership of Citrix, so it is unlikely 
that the code will stagnate or become a burden to other maintainers.

Since the state of Xen dom0 was not addressed in the 2.6.30-rc1 thread, 
please state your intentions here.

Regards,

Kevin


