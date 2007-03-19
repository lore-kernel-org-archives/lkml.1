Return-Path: <linux-kernel-owner+w=401wt.eu-S965751AbXCSHzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751AbXCSHzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 03:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965819AbXCSHzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 03:55:33 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:5096 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965751AbXCSHzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 03:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NKVEYRp1mWdWvrFRiir4gHapd8RKgpgjk/jLN+ozRGePMk6L21ZiSg2DJH9rzJReBsU9mQN0SiEI2NZr1e482k2Du+chcLYNfyQ63GWDbA6Q+R+AAWt+QOXU9A0UYedfXsFjYW7++tEdgafI4F4hPsLAr+1iTvNXj+w4QGiAyKw=
Message-ID: <45FE41ED.20100@gmail.com>
Date: Mon, 19 Mar 2007 16:55:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
References: <005501c769fa$ee402470$4b00a8c0@donald>
In-Reply-To: <005501c769fa$ee402470$4b00a8c0@donald>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
>> Oh... that's just weird.  It seems you'll have to continue 
>> boot with the
>> timeouts for the time being.  Sorry about that.
> 
> Would you agree to a patch to add a kernel boot parameter to skip some
> ata ports ?
> I found some archives refering to some "ataX=noprobe", but it seems
> to have no effect, and I'd like to resurrect it for libata, at least to
> help me support my configuration ?
> If no, I'll just cook it for me, without posting it...

Why not cook it and share it?  :-)

-- 
tejun
