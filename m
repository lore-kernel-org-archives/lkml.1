Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab0BLT4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:56:12 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:57435 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756710Ab0BLT4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:56:10 -0500
Message-ID: <4B75B2A6.5080006@lougher.demon.co.uk>
Date: Fri, 12 Feb 2010 19:57:26 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	<20100212150137.648dca7c@hyperion.delvare>	<4B75A5CF.70308@lougher.demon.co.uk> <20100212203209.0cb8afc3@hyperion.delvare>
In-Reply-To: <20100212203209.0cb8afc3@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Fri, 12 Feb 2010 19:02:39 +0000, Phillip Lougher wrote:
>> 5* Archive all the older 2.6.x files and move them into a separate
>>     directory (e.g. v2.6-pre20).  Moving all the pre 2.6.20 files
>>     saves 42% of the file listing.
>>
>> This seems an obvious solution, what am I missing?
> 
> This is confusing, inconsistent and unstable. Confusing because 2.6-pre
> referred so far to the releases immediately preceding 2.6.0.

I didn't say "2.6-pre", anyway it could be called something different,
like 'older-releases'.

> Inconsistent because it requires the downloader to have preliminary
> knowledge about what the break point is. Unstable because, while you
> consider pre20 to qualify as "old" today, in 5 years you will want
> pre30 to qualify as "old" instead, meaning that tools such as ketchup
> would have to be updated once again.

You yourself said "I wouldn't worry too much about breaking the current locations.
Just give some time for software authors (ketchup comes to mind) to update
their code and it shouldn't be a big problem."

The major advantage with my suggestion is for the majority of users/tools
interested in "recent" kernels, nothing changes at all.  Your suggestions
break everything for everyone.

> 
> I think we want to come up with a directory structure which won't change
> in the future.
> 

I think trying to do that is utterly futile.

Phillip
