Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXEDPXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXEDPXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXEDPXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:23:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:45751 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbXEDPXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mSeSGULQitWDjZthbPcmhqVaNZZTkHrtC2qem3VV5SymWK23ja38RPZUDWb97nct3zvOfTwdJ0iyn86qWsBf4mlVukIspBcUqJVTSo8/+0cLGYJ+AsAgY7hPNWTqHglgD9Wjkn4xaXs8NjL2kHsmBG0ahC7pTxqzGj+tKx3APyA=
Date: Fri, 4 May 2007 23:27:52 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: la deng <ladeng.mimi@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: c 's OOP in VFS vs c++'s OOP
Message-ID: <20070504152752.GB4258@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: la deng <ladeng.mimi@gmail.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <99e4df080705040132m41116db3y50c73c79528d6206@mail.gmail.com> <20070504101129.GA5482@localhost.localdomain> <99e4df080705040400p66819117sec7f7d88d3794871@mail.gmail.com> <Pine.LNX.4.61.0705041339220.18504@yvahk01.tjqt.qr> <20070504123047.GA2255@localhost.localdomain> <99e4df080705040653l38daa61aw3883b7c55c8e9de7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99e4df080705040653l38daa61aw3883b7c55c8e9de7@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 09:53:34PM +0800, la deng wrote:
>On 5/4/07, WANG Cong <xiyou.wangcong@gmail.com> wrote:
>>On Fri, May 04, 2007 at 01:40:04PM +0200, Jan Engelhardt wrote:
>>>
>>>On May 4 2007 19:00, la deng wrote:
>>>>
>>>>
>>
>>C gives you the power to control nearly everything. You can, of course, 
>>control the registers via inserting assembly code. That's not the fault of 
>>C.
>I think you don't understand me correctly
>
>I know c can inline assmebly to control registers
>
>but,this control not the globe Analysis of control register like
>internal of c++ compiler or lisp 's compiler language,c can't
>
>sigh

You didn't understand me correctly.

I mean that C gives you the power to control them, you can do analysis and then do what you like. It's up to you. But I think if you add optimizing options, the compiler won't be so foolish as what you say.

So, can we stop now?

