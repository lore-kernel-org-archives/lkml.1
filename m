Return-Path: <linux-kernel-owner+w=401wt.eu-S1766945AbXDSTJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766945AbXDSTJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766947AbXDSTJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:09:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60067 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766945AbXDSTJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:09:37 -0400
Message-ID: <4627BE6B.8030006@garzik.org>
Date: Thu, 19 Apr 2007 15:09:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net
Subject: Re: [GIT PULL] kvm oops fix
References: <1176997839110-git-send-email-avi@qumranet.com> <alpine.LFD.0.98.0704190949580.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704190949580.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 19 Apr 2007, Avi Kivity wrote:
>> Please pull from the 'linus' branch of
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git
> 
> *please* put the branch-name after the git repo, so that I can 
> cut-and-paste without noticing only afterwards that the diffstat doesn't 
> match what it was supposed to, and I got the wrong commits, and have to 
> undo and re-do the pull..

What is the easiest way to completely undo a pull, reverting the branch 
to the HEAD present before the pull?

	Jeff



