Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbZLZICr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbZLZICr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 03:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZLZICq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 03:02:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:40951 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbZLZICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 03:02:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=i6gLCZle8Dq9KooWpubTR6PF6oVDO0SGR8kvh3DOssZ4y/qyXPVPUjcbfo5pn3YtMu
         Q8TDh5/YD4+gGTvr3EHVLkMlecU1u54KVFKww3basX31u2sb5SGvqCLt2F0YDsSFw/Si
         pTZ0dxVMhSAWi9NJ3imvkUvu9gTuy5gLQtUzc=
Date: Sat, 26 Dec 2009 09:02:40 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: Linux 2.6.33-rc2 - Merry Christmas ...
Message-ID: <20091226080240.GA12286@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	David Miller <davem@davemloft.net>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091225200017.GA4095@liondog.tnic>
 <20091225215032.GA32581@liondog.tnic>
 <20091225220031.5b06fc49@jbarnes-x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091225220031.5b06fc49@jbarnes-x200>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 10:00:31PM -0800, Jesse Barnes wrote:
> There should be a fix queued in my for-linus branch (I've been out this
> week so haven't sent the pull req yet), can you give it a try and make
> sure?

Yep, 2820f333e3b4ad96590093efbed7b3400bcf492b fixes it.

Thanks.

-- 
Regards/Gruss,
    Boris.
