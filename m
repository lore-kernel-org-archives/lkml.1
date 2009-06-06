Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZFFW6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZFFW6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZFFW6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:58:14 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36766 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbZFFW6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:58:13 -0400
Date: Sat, 6 Jun 2009 23:58:02 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Woody Suwalski <woodys@xandros.com>, jbarnes@virtuousgeek.org,
       eric@anholt.net, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       stable@kernel.org, tim.gardner@canonical.com,
       stefan.bader@canonical.com
Subject: Re: Intel 915GM MCHBAR bug
Message-ID: <20090606225802.GL10751@shadowen.org>
References: <4A242C81.6020906@cs.helsinki.fi> <4A298971.5080006@xandros.com> <4A2A0951.1020608@cs.helsinki.fi> <20090605232711.d8503262.akpm@linux-foundation.org> <4A2A0E8C.1010109@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2A0E8C.1010109@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 09:37:00AM +0300, Pekka Enberg wrote:
> Hi Andrew,
>
> On Sat, 06 Jun 2009 09:14:41 +0300 Pekka Enberg <penberg@cs.helsinki.fi>  
> wrote:
>>>>> Wanna show us the patch?
>>>>>
>>>>> Because the world could certainly do with more i915 bugfixes :(
>>>>   Here is Jesse's patch from  
>>>> http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html 
>>>> adopted for 2.6.30-rc8... (needed to redo hunk #3 for 
>>>> i915_gem_tile.c)
>>> Yup. I took the two patches from here:
>>>
>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/349314
>>>
>>> and did the same rediffing on top of 2.6.30-rc8 for the first one.
>>>
>>> Andrew, do you want me to forward you the (tested) patches or should 
>>> we wait for Jesse et al to take care of it?
>>
>> Yes, please send them out.
>
> OK, I did that. I am bit unhappy that I had to do it, though. The patch  
> dates back to January (!) and Ubuntu folks have been carrying it for a  
> while now.

We cirtainly have been carrying for some time.  My understanding was
that the maintainers had it and had been expecting it to merge through
them.  Did we miss a trick somewhere?

-apw
