Return-Path: <linux-kernel-owner+w=401wt.eu-S1752554Ab0AZGde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0AZGde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060Ab0AZGdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:33:33 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:36552 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0AZGdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:33:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=a0xH9CQK4Xx7tZTNsz1Lzn0WVmHmRgzGJYQRLdZwEDrPl+OwJ1r5nqB2ZijzaKsZnh
         mipRrKlrgZB0fQ/41STYhg0bxAwrmntZ6thVhOvd5FhxiPMP6P9pgO79BMUsfkSBXFXi
         ixJsNOYr6ezBdixP3bURWkjodKh9/99UspCKw=
Date: Tue, 26 Jan 2010 06:33:26 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20100126063326.GA6360@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125.165634.92235663.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-01-2010 01:56, David Miller wrote:
> 1) SKY2 revert to fix a resume regression, from Stephem Hemminger
> 
> 2) We can end up trying to remove/proc/net/rt_acct when exiting
>    a namespace even when we didn't create it in the first place.
>    Fix from Alexey Dobriyan.
...
> Please pull, thanks a lot!
> 
> The following changes since commit f6760aa024199cfbce564311dc4bc4d47b6fb349:
>   Linus Torvalds (1):
>         Merge branch 'timers-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

David, I hope I miss something, but there seem to be older things too:
...
> Jarek Poplawski (1):
>       ax25: netrom: rose: Fix timer oopses

Jarek P.
