Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYKNAZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYKNAZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYKNAZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:25:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:24278 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYKNAZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:25:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qzxLh0LANvPJMN4+icSyAoMpbPCJ8xWSf7oKdVKjVCjd2OV2Mqiry8jCVUfxopOYuH
         FkIqxfQmi5SjRlHLlCAmGLvxS8NkjSwlm1fCXM0ZgGs6xSMgQmBOJrllnaPtY5mFrfo4
         J14e7DB9OgCvo9H2UWE+C6dUV6xgHjWexKYb0=
Message-ID: <3aaafc130811131625l4a1e4b3ck72f9041a8159b599@mail.gmail.com>
Date: Thu, 13 Nov 2008 19:25:29 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Can you add the staging tree to -next?
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081114002203.GA20272@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081112235600.GA27554@kroah.com>
	 <20081114104421.772feee3.sfr@canb.auug.org.au>
	 <20081114000133.GA19644@kroah.com>
	 <3aaafc130811131613j1f4425deodcb3b3f9fd330653@mail.gmail.com>
	 <20081114002203.GA20272@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 7:22 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Nov 13, 2008 at 07:13:40PM -0500, J.R. Mauro wrote:
>> On Thu, Nov 13, 2008 at 7:01 PM, Greg KH <greg@kroah.com> wrote:
>> > On Fri, Nov 14, 2008 at 10:44:21AM +1100, Stephen Rothwell wrote:
>> >> Hi Greg,
>> >>
>> >> On Wed, 12 Nov 2008 15:56:00 -0800 Greg KH <greg@kroah.com> wrote:
>> >> >
>> >> > I'm starting to get people sending me patches against -next for the
>> >> > drivers/staging/ tree that don't apply as -next does not include my
>> >> > quilt tree of staging patches.
>> >> >
>> >> > Can you please pick it up?  You can put it at the end of your series,
>> >> > and the 'make allmodconfig' option disables building anything in the
>> >> > drivers/staging/ subdirectory, so it should not have any build or merge
>> >> > conflicts with anything.
>> >> >
>> >> > It can be found at:
>> >> >     http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/
>> >> > and is a quilt tree.
>> >> >
>> >> > It will follow all the same rules as other trees, with patches only for
>> >> > the next merge window (2.6.29 right now) in it.
>> >>
>> >> OK, I have added it starting today.
>> >
>> > Thank you very much, I appreciate it.
>>
>> Greg, will this suffice for having a git repo for staging, or are you
>> still planning on a discrete staging repo?
>
> For now, this is probably going to be sufficient for me, how about you?

Should work fine

>
> thanks,
>
> greg k-h
>
