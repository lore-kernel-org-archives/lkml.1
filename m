Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXDWGOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXDWGOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXDWGOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:14:07 -0400
Received: from [70.254.190.220] ([70.254.190.220]:34670 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753532AbXDWGOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:14:05 -0400
Date: Mon, 23 Apr 2007 06:14:04 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Rik van Riel <riel@redhat.com>
cc: Eric Hopper <hopper@omnifarious.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
In-Reply-To: <462C4D32.4000909@redhat.com>
Message-ID: <Pine.LNX.4.64.0704230611430.25153@server.thyself>
References: <20070423020046.GA28477@omnifarious.org> <462C2E5B.1080008@redhat.com>
 <Pine.LNX.4.64.0704230353000.25153@server.thyself> <462C4858.3050006@redhat.com>
 <Pine.LNX.4.64.0704230555020.25153@server.thyself> <462C4D32.4000909@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Rik van Riel wrote:
> William Heimbigner wrote:
>
>>  However, is the code really in such a shape that the community doesn't
>>  want to maintain it? Obviously there's a significant number of people
>>  interested in reiser4 - if there weren't, questions like this wouldn't
>>  keep getting asked.
>
> There are people interested in using it, yes.
>
> However, nobody appears to have stepped up to maintain the code.
> If somebody really wanted to maintain the code, there would be a
> new maintainer already.

On that note, what exactly is wanted for (assuming there was a maintainer) 
reiser4 to be suitable for inclusion in the kernel? To my knowledge (and 
I'll admit, I haven't looked in to it very far) the primary reason for 
rejection was that it broke coding standards.

If there was 1) a maintainer and 2) code that didn't break "coding 
standards", would it be included in the kernel?

William Heimbigner
icxcnika@mar.tar.cc
