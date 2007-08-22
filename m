Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbXHVMXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbXHVMXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbXHVMXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:23:44 -0400
Received: from 1wt.eu ([62.212.114.60]:2231 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758248AbXHVMXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:23:44 -0400
Date: Wed, 22 Aug 2007 14:10:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
Message-ID: <20070822121049.GA10979@1wt.eu>
References: <20070822083844.%N@1wt.eu> <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Wed, Aug 22, 2007 at 01:10:44PM +0200, Michal Piotrowski wrote:
> Hi Willy,
> 
> On 22/08/07, Willy Tarreau <w@1wt.eu> wrote:
> > This is the start of the review cycle for the stable 2.6.20.17
> > kernel release. This version catches up with 2.6.22.4, and 58
> > patches will be posted as a response to this message.
> >
> > The following security issues are solved :
> >   CVE-2007-3105
> >   CVE-2007-3848
> >   CVE-2007-3851
> >
> > The rolled up patch can be found here :
> >    ftp.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.20.17-rc1.gz
> >
> > Responses should be made by August 24, 2007, 19:00:00 UTC. Anything
> > received after that time might be too late.
> 
> I got a problem with SELinux
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/console.log
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/stable-config
> 
> rpm -qa selinux-policy*
> selinux-policy-devel-2.6.4-33.fc7
> selinux-policy-2.6.4-33.fc7
> selinux-policy-targeted-2.6.4-33.fc7
> 
> I didn't tested 2.6.20.* since 2.6.20 release so it might take some
> time to figure out.

I'm a total looser in selinux, so I'll not be able to help here. Could you
please test if 2.6.20.16 works ? It would at least tell us if it's one of
the patches in 17-rc1.

Thanks,
Willy

