Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYHZVMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYHZVMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYHZVMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:12:23 -0400
Received: from gw.goop.org ([64.81.55.164]:54509 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYHZVMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:12:22 -0400
Message-ID: <48B471B4.9030202@goop.org>
Date: Tue, 26 Aug 2008 14:12:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] block bits
References: <20080826070640.GR20055@kernel.dk> <alpine.LFD.1.10.0808261009180.3363@nehalem.linux-foundation.org> <20080826185636.GP20055@kernel.dk> <alpine.LFD.1.10.0808261201420.3363@nehalem.linux-foundation.org> <20080826191031.GQ20055@kernel.dk>
In-Reply-To: <20080826191031.GQ20055@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Aug 26 2008, Linus Torvalds wrote:
>   
>> On Tue, 26 Aug 2008, Jens Axboe wrote:
>>     
>>> I'll move those 1-2 patches to the 2.6.28 branch and resubmit the rest
>>> for you.
>>>       
>> You will *delete* the absolute crap locking patch, that has no way of 
>> being even 2.6.28 material.
>>     
>
> Yeah, I thought that was obvious, I'll bounce it back to the Xen folks.
>   

Which, what?  Was there an objection to one of the blkfront patches?  (I
don't remember anything locking related in there anyway.)

    J
