Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXAVTUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXAVTUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXAVTUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:20:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41813 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbXAVTUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:20:31 -0500
Message-ID: <45B50E78.7000107@garzik.org>
Date: Mon, 22 Jan 2007 14:20:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Auke Kok <auke-jan.h.kok@intel.com>
CC: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
References: <20070122185508.GA4648@havoc.gtf.org> <45B50A73.7000000@intel.com>
In-Reply-To: <45B50A73.7000000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Auke Kok wrote:
> Jeff Garzik wrote:
>> Please pull from 'upstream-linus' branch of
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git 
>> upstream-linus
> 
> Jeff,
> 
> is there a reason that you didn't pull the e1000 tree from us? I send 
> you all the information 5 days ago, WITH the changes that you requested.

I did pull the tree.  The fixes were far more than just obvious 
one-liners, so they got pulled into #upstream.

Given the past history of breakage during -rc from huge Intel "fix" 
patchsets, there's no way I'm going to push those fixes to Linus without 
plenty of testing in -mm first.

	Jeff



