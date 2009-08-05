Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZHEP2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZHEP2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZHEP2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:28:05 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:45364 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbZHEP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OyV/U+KOxqxuIF1SRww9JTiMoquLOdIoXK+B5LO4+vwzDyABsrJnvjrovZQeOUHcZF
         XV/oxdO5hL5txtkW1AlonMq4DZ9PMK/8496Cvhz7AyKVW6S3vQuUT8xpDUu37MJJqBG/
         CxqanKkGWFejoKJnGeVsSBmNfa3zkpDrA/tRY=
Date: Wed, 5 Aug 2009 23:30:50 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, scgtrp@gmail.com,
       xiyou.wangcong@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + kcore-fix-vread-vwrite-to-be-aware-of-holes.patch added to
	-mm tree
Message-ID: <20090805153050.GA4612@hack>
References: <200908042130.n74LUxr8027929@imap1.linux-foundation.org> <20090805163846.25caf6ea.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805163846.25caf6ea.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 04:38:46PM +0900, KAMEZAWA Hiroyuki wrote:
>On Tue, 04 Aug 2009 14:30:58 -0700
>akpm@linux-foundation.org wrote:
>
>> 
>> The patch titled
>>      kcore: fix vread/vwrite to be aware of holes
>> has been added to the -mm tree.  Its filename is
>>      kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
>> 
>This is a replacement. Fixed comments where concerns are pointed out.
>
>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>

<snip>

>
>Changelov v3->v3.1
> - fixed comments. (mainly vread/vwrite description is updated.)
> - use KM_USER0 instead of KM_USER1

Nice!

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thank you!
