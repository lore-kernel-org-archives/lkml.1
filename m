Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYELTs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYELTs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYELTsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:48:21 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:9460 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYELTsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:48:20 -0400
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: jclyXLBJ10ZHTmMMskdeEV9K+qamm4K24+0GzTHYHnheuzKtvddXf0g5IDpOVsJr
Message-ID: <48289F00.9010406@hartkopp.net>
Date: Mon, 12 May 2008 21:48:16 +0200
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Romano Giannetti <romanol@upcomillas.es>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com>	 <48198873.7030503@hartkopp.net>  <481A06C0.6070500@zytor.com> <1210163964.14371.1.camel@localhost> <48282C69.2070006@hartkopp.net> <48286364.7010107@zytor.com> <48288E4E.3080107@hartkopp.net> <48289C59.5040401@zytor.com>
In-Reply-To: <48289C59.5040401@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Oliver Hartkopp wrote:
>> H. Peter Anvin wrote:
>>> Oliver Hartkopp wrote:
>>>>
>>>> Yes - this was also my intention. I don't have any preferences if
>>>> the first commit after a release is named -merge or -rc0. But it
>>>> should point out that we're leaving the former stable release.
>>>>
>>>
>>> Either way it'll take a bunch of work.
>>
>> Can you give any details?
>>
>> Why does tagging a -rc0 create any effort for anyone - except half a
>> minute for Linus?
>>
>
> Because it breaks all the robots which rely on the kernel naming scheme.
>

This is no real detail. How can -rc0 break a naming scheme for a robot,
when -rc1 doesn't?

Btw. you don't seem to have any interest in my suggestion and obviously
Linus, Greg and Andrew also do not have any interest in something like a
-rc0. So i won't create any new noise about that topic from my side.

Thanks anyway,
Oliver

