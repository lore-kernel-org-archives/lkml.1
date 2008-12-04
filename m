Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYLDSbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYLDSbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYLDSbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:31:35 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43662 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYLDSbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:31:34 -0500
Message-ID: <49382201.8030609@hp.com>
Date: Thu, 04 Dec 2008 13:31:29 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at block/blk-timeout.c:178!
References: <4937E888.3060208@hp.com> <20081204155005.GX18255@kernel.dk> <493801AF.8050308@hp.com>
In-Reply-To: <493801AF.8050308@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:
> Jens Axboe wrote:
> 
>> Alan, can you try latest -git? feaf3848a813a106f163013af6fcf6c4bfec92d9
>> or later.
>>
> 
> git pull()ed to: feaf3848a813a106f163013af6fcf6c4bfec92d9 and the same
> problem occurs.

Maybe not - I've not been to reproduce that problem in subsequent
reboots. It could be that I booted the wrong kernel first time (rc6
instead of rc7). Will keep plugging - any idea as to what might have
"fixed" the problem between rc6 & rc7?

Alan
