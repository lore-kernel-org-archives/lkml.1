Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbZDSGrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbZDSGrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZDSGrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:47:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:51638 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbZDSGrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hdfbIuSGZhuTm6crlrZqKEuMe5tOjH0HALbb9Gg7ZCPA4BJOdyOc9AZ20dWISwQCtP
         s354NCYkJUb6dL8a2bYFbxTimY7FbAjzjY2T55LO0bMcv6jhCmBMJOsypxjOjWLSLlaI
         VmY1yM9w3qCvSWDFiGuiTG8NkV1QK2YKUIwW8=
MIME-Version: 1.0
In-Reply-To: <1240086216.11172.2954.camel@gaiman.anholt.net>
References: <1240001399.11172.121.camel@gaiman.anholt.net>
	 <20090418.015905.92829818.davem@davemloft.net>
	 <1240086216.11172.2954.camel@gaiman.anholt.net>
Date: Sun, 19 Apr 2009 16:47:30 +1000
Message-ID: <21d7e9970904182347m1dbb611dp3a71f16b0fd82bb7@mail.gmail.com>
Subject: Re: [git pull] Fixes to 2.6.30rc2
From: Dave Airlie <airlied@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 6:23 AM, Eric Anholt <eric@anholt.net> wrote:
> On Sat, 2009-04-18 at 01:59 -0700, David Miller wrote:
>> From: Eric Anholt <eric@anholt.net>
>> Date: Fri, 17 Apr 2009 13:49:59 -0700
>>
>> >   git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-next
>>
>> Eric, any plans to ever push your work through David Airlie's DRM
>> tree?  I've been watching this for a few weeks and I'm mystified why
>> the Intel DRM drier stuff is so special that is always goes seperate.
>>
>> It's seems foolish for David to manage the infrastructure and core DRM
>> changes, as well as those for radeon and the other drivers other than
>> Intel, which could potentially cause merge issues and conflicts with
>> your driver changes.
>>
>> Why not do Intel DRM driver development via his tree?  I just don't
>> get it. :-/
>
> Inside of the merge window, I am going through Dave again because he
> requested it (though delays meant that I didn't get a major cleanup in
> this merge window).  However, Dave is also quite busy, and not stealing
> his time every few days to pull my tree for just forwarding bugfixes on
> seems to be a win.

btw which cleanup, I seem to remember it arriving after the merge
window had opened.

The theory is the code was in my tree before Linus opened the window
or it doesn't
get merged.

Dave.

>
> --
> Eric Anholt
> eric@anholt.net                         eric.anholt@intel.com
>
>
>
