Return-Path: <linux-kernel-owner+w=401wt.eu-S1766966AbXDSTeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766966AbXDSTeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766968AbXDSTeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:34:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60238 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766966AbXDSTeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:34:07 -0400
Message-ID: <4627C429.2020500@garzik.org>
Date: Thu, 19 Apr 2007 15:34:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Brown <dmlb2000@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL] kvm oops fix
References: <1176997839110-git-send-email-avi@qumranet.com>	 <alpine.LFD.0.98.0704190949580.9964@woody.linux-foundation.org>	 <4627BE6B.8030006@garzik.org> <9c21eeae0704191224g104f4an96b330c6b77c29a7@mail.gmail.com>
In-Reply-To: <9c21eeae0704191224g104f4an96b330c6b77c29a7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brown wrote:
>> What is the easiest way to completely undo a pull, reverting the branch
>> to the HEAD present before the pull?
>>
> 
> If the pull doesn't merge successfully then usually doing a `git-reset
> --hard` will blow everything away back to normal, but Linus may do
> different things.

I'm thinking about a successful pull that one later regrets :)

	Jeff



