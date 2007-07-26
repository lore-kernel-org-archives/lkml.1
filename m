Return-Path: <linux-kernel-owner+w=401wt.eu-S1763802AbXGZGqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763802AbXGZGqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbXGZGq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:46:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:58998 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbXGZGq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:46:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s65pc+3WuDHHYmsqmJOUHX7ZGBdvgZjuvbOGaSz2gxGlA0qH1PwwFE5iBFhRu2Moa+FS0F5W3jH/Og7I29rqvJmQNogMAP3l3nOMYsAIKpKVJQ1Jgzw+R+rK0fRNViMomubdIRUHTN8MSlieYA8KVNODHrqmLPQKyHzOlRFC+Jo=
Message-ID: <a8e1da0707252346r471c66f5ycac75a0ec69b5b94@mail.gmail.com>
Date: Thu, 26 Jul 2007 06:46:26 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH][resend] sysfs/file.c - use mutex instead of semaphore
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070726054600.GA25263@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070726110354.GA3672@darkstar.te-china.tietoenator.com>
	 <20070726054600.GA25263@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/26/07, Greg KH <gregkh@suse.de> wrote:
> On Thu, Jul 26, 2007 at 11:03:54AM +0000, Dave Young wrote:
> > Use mutex instead of semaphore in sysfs/file.c : sys_buffer.
>
> Thanks, it's in my queue, but I'm at a conference this week, so I'll get
> to it on monday, sorry for the delay.
>
Hi, thank you. I'm not sure why it's ignored, I think maybe it should
be splitted to two patches.

Andrew has added this one to -mm tree. I'm happy to hear from you. I
will send the seperated header cleanup patch again. gmail will convert
 tab to white space, so I have to send another post.
