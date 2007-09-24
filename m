Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbXIXQrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbXIXQrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761219AbXIXQja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:39:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49725 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762078AbXIXQj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:39:28 -0400
Message-ID: <46F7CE80.4070805@oracle.com>
Date: Mon, 24 Sep 2007 07:49:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux/mutex.h: unclear reference to convention
References: <377076.1597.qm@web52004.mail.re2.yahoo.com>
In-Reply-To: <377076.1597.qm@web52004.mail.re2.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matti Linnanvuori wrote:
> Randy Dunlap <randy.dunlap@oracle.com>:
>> Another convention is that we put kernel-doc with the implementation
>> (i.e., in .c files) when possible, not with the function prototype.
>> Of course, for inline functions or macros in header files, that's
>> where the kernel-doc has to live.
>>
>> so we don't need this patch.
> 
>  You should not expect that every reader of the kernel files is aware of 
> that convention. I was not and therefore I sought referenced files for 
> some time.

Sure, I agree with you.
Where should we put this information so that people will find it?

-- 
~Randy
Phaedrus says that Quality is about caring.
