Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab0BTPla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:41:30 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:52154 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab0BTPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jihUm5Lm5jvTNdQ4g6IsmhDuIFdwi+rPdhCx783QTyzu9BQFQ9ToTW68TXbbZEfb9E
         6j5ouxWcdrymGOfd9qAmgMJEwK/3Ls4hZz+RUGZx65hinc/I7U5mSYEPo+9BeHHi9Dx7
         o/vfxgk9H2E7HDzOQlgq/73qTvC43/580MmaY=
Date: Sat, 20 Feb 2010 23:44:08 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: sysfs lockdep complaint
Message-ID: <20100220154408.GN3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net> <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com> <1266664814.11514.5.camel@jlt3.sipsolutions.net> <20100220135122.GB3000@hack> <1266674493.18465.9.camel@jlt3.sipsolutions.net> <20100220150327.GG3000@hack> <1266678496.32309.1.camel@jlt3.sipsolutions.net> <20100220152010.GI3000@hack> <1266679687.17363.1.camel@jlt3.sipsolutions.net> <1266679883.17363.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266679883.17363.3.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 04:31:23PM +0100, Johannes Berg wrote:
>On Sat, 2010-02-20 at 16:28 +0100, Johannes Berg wrote:
>
>> I have this now, and that removed all the warnings:
>
>But I still don't get anything back wrt. the original problem ... still
>hangs after printing "disabling non-boot CPUs"
>

Odd, it seems we still have some problem... maybe my quick patch is
broken, I will check it tomorrow, it's mid-night here. :)

Thanks.

