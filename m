Return-Path: <linux-kernel-owner+w=401wt.eu-S965924AbXGTAxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965924AbXGTAxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939881AbXGTAwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:52:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42181 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S939821AbXGTAwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:52:40 -0400
Message-ID: <46A00752.4040103@sgi.com>
Date: Fri, 20 Jul 2007 10:52:34 +1000
From: Timothy Shimmin <tes@sgi.com>
User-Agent: Thunderbird 2.0.0.4 (Macintosh/20070604)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] XFS update
References: <469F7329.9080603@sgi.com> <alpine.LFD.0.999.0707191528250.27249@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707191528250.27249@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 20 Jul 2007, Tim Shimmin wrote:
>> Please pull from the for-linus branch:
>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> Ok, this got some conflicts with Nick's VM fault patches, but I fixed them 
> up since they looked trivial, and pushed out the result. Please do verify 
> that it all works and makes sense, though...
> 
> 		Linus

Okay, sorry and thanks.

The window between pulling in and applying changes was obviously
large enough for Nick's changes to get in.
I did pull in, and then had hassles in converting changes between
sgi dev tree and git mainline. Then by the time they were fixed, scripts
updated, had dinner, tree built, had failure with posix_test_lock (fixed that -
then noticed others fixed it - wish I had pulled in at this stage:)
and ran thru some qa, Nick's changes must have gone in.
Ok, next time must remember to repull in latest just before sending out
as a final check.

--Tim
