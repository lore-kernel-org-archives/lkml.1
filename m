Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXIFJ57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXIFJ57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 05:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXIFJ5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 05:57:51 -0400
Received: from gw.goop.org ([64.81.55.164]:38650 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbXIFJ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 05:57:51 -0400
Message-ID: <46DFCF1A.8090808@goop.org>
Date: Thu, 06 Sep 2007 10:57:46 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Fix preemptible lazy mode bug
References: <46CE70C8.2030005@vmware.com> <1189024666.10802.197.camel@localhost.localdomain> <1189036175.21516.31.camel@bodhitayantram.eng.vmware.com> <200709060641.36855.ak@suse.de>
In-Reply-To: <200709060641.36855.ak@suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I agree.  The patch is a nop.  I just got overly paranoid.  The whole
>> thing is just very prone to bugs.
>>     
> So do we need a patch for .23 or not?
>   

Forgot this bit.  No, I think the upshot is that it isn't necessary (nor
Rusty's).

    J
