Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab0CMF07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 00:26:59 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59775 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0CMF0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 00:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x2McRpxhueLgiRqyVqNvAF8gOd8yVn/53B5Xt2c/vv2JJpmuemmhuzNk/ng4gytZQS
         x1Ut1sBdI/Ocfs9w5dmS5Okx/h1o33aNRTasUMFEdIV4PvcOfxjwTmJJgxyHnn0AGW0p
         bGriFuzZcOQUdZPKVtldYF+gX94ac2sZyoiLM=
Date: Sat, 13 Mar 2010 13:29:56 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       =?utf-8?B?UGVudHRpbMOk?= Mika <mika.penttila@ixonos.com>
Subject: Re: [PATCH 0/7] tcp: bugs and cleanup for 2.6.34-rc1
Message-ID: <20100313052956.GA3704@hack>
References: <4B98D592.6040301@gmail.com> <1268319664.2986.535.camel@edumazet-laptop> <4B992A89.6040700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B992A89.6040700@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 12:38:17PM -0500, William Allen Simpson wrote:
> On 3/11/10 10:01 AM, Eric Dumazet wrote:
>> It would be nice if you could update your knowledge of how linux
>> development works these days.
>>
> Perhaps you could supply pointers to the relevant documentation?
>
>

Documentation/development-process/* are still nice documents.
