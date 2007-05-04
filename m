Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXEDM0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXEDM0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXEDM0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:26:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:17562 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbXEDM0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bAFBJppvIeQg569h55G66W0AjtUjmQl1CA5NlACNVgEDpUc2FKA/xOF7S5LxrPqh8Fk0p2Bzf3cFxXrJ/L30dkUV/S0Yic8Bih6sjtZtiWuAJoPNiTjKq16+Nwcjc4rr5OyX343UliEoQWYrZGyFu3GvxC/dMz7UV0glEvba2Bw=
Date: Fri, 4 May 2007 20:30:47 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: la deng <ladeng.mimi@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: c 's OOP in VFS vs c++'s OOP
Message-ID: <20070504123047.GA2255@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	la deng <ladeng.mimi@gmail.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <99e4df080705040132m41116db3y50c73c79528d6206@mail.gmail.com> <20070504101129.GA5482@localhost.localdomain> <99e4df080705040400p66819117sec7f7d88d3794871@mail.gmail.com> <Pine.LNX.4.61.0705041339220.18504@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705041339220.18504@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 01:40:04PM +0200, Jan Engelhardt wrote:
>
>On May 4 2007 19:00, la deng wrote:
>>
>> What's you think about it?

C gives you the power to control nearly everything. You can, of course, control the registers via inserting assembly code. That's not the fault of C.

>
>I think the discussion should stop right here, because the kernel
>will not be transformed into C++ anytime soon.
>
>
>Jan

OK. Stop here.

Regards!

