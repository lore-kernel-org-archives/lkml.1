Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbXG0Aiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbXG0Aiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbXG0Aiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:38:46 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:9563 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbXG0Aip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e3qnUbc8l0tl1oSxpFy2GlAc0UFbSQIE4e/PcmM4iP9YJQk3j6qOVvH+tAsgAxtiAkkhztAYH7hShmKlMxQKLDGqjyO79V/yBZPugIZmoLJndwm53rY5wGdaCRQmkAc6XUhkWXTJtx+jiPI7oleHEeb6uFFoye2nPm/STzNAy9k=
Message-ID: <a8e1da0707261738q72e13b32k3fb49ab750d60fc7@mail.gmail.com>
Date: Fri, 27 Jul 2007 00:38:44 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "WANG Cong" <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH][resend] sysfs/file.c - use mutex instead of semaphore
Cc: "Greg KH" <gregkh@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070726120334.GA2404@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070726110354.GA3672@darkstar.te-china.tietoenator.com>
	 <20070726054600.GA25263@suse.de>
	 <a8e1da0707252346r471c66f5ycac75a0ec69b5b94@mail.gmail.com>
	 <20070726120334.GA2404@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/26/07, WANG Cong <xiyou.wangcong@gmail.com> wrote:
> On Thu, Jul 26, 2007 at 06:46:26AM +0000, Dave Young wrote:
> >>On 7/26/07, Greg KH <gregkh@suse.de> wrote:
> >> On Thu, Jul 26, 2007 at 11:03:54AM +0000, Dave Young wrote:
> >> > Use mutex instead of semaphore in sysfs/file.c : sys_buffer.
> >>
> >> Thanks, it's in my queue, but I'm at a conference this week, so I'll get
> >> to it on monday, sorry for the delay.
> >>
> >Hi, thank you. I'm not sure why it's ignored, I think maybe it should
> >be splitted to two patches.
> >
> >Andrew has added this one to -mm tree. I'm happy to hear from you. I
> >will send the seperated header cleanup patch again. gmail will convert
> > tab to white space, so I have to send another post.
>
> Well, it seems that you use web browsers to visit gmail. Can you try to
> use an email client, such as claws mail, mutt, or even git-send-email?
> I am using gmail with mutt, tabs aren't replaced.
>
Yes, I use  webmail to write messages other than patches, the patches
are sent by mutt.
