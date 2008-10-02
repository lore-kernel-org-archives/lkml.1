Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYJBRks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYJBRks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 13:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYJBRkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 13:40:41 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:55906 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbYJBRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 13:40:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=e5YlbBJY2Fb3Po4hA/FgXMNb8ar6Qh4gL+yvLac/G5Xb7UROhBUTa0we0Hw0B24t;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <48E50796.1010502@earthlink.net>
Date: Thu, 02 Oct 2008 13:40:38 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Automatic config file generator
References: <48E4FC91.5010300@earthlink.net> <20081002170210.GB7998@localhost>
In-Reply-To: <20081002170210.GB7998@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79dfb343e1d96932be9d66190e5f44bc86350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Stephen Clark - Thu, Oct 02, 2008 at 12:53:37PM -0400]
>> Hello List,
>>
>> Is there a utility that will examine your system and generate a tailored 
>> config file so I don't have to compile a zillion modules.
>>
>> Currently when I want to build the latest kernel I take the config file from
>> my distro, (fedora), but it has every module in the world. So on my
>> 1.8ghz core 2 duo laptop it takes about 30 min to build a new kernel.
>>
>> Thanks,
>> Steve
>> -- 
>>
>> "They that give up essential liberty to obtain temporary safety,
>> deserve neither liberty nor safety."  (Ben Franklin)
>>
>> "The course of history shows that as a government grows, liberty
>> decreases."  (Thomas Jefferson)
>>
>>
> 
> You could be interested by this thread
> 
> 	http://lkml.org/lkml/2008/9/16/290
> 
> 		- Cyrill -
> 
Thanks,

Somehow I missed that thread.

Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


