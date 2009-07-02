Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZGBLzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZGBLzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZGBLy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:54:56 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36644 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZGBLyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tgs2lWVazcTnKD3ZVdyGio5dMbWuesJtLhL2+XW6WRrT1dZL78c7TlcWxREZJG/XVr
         3jQqyu2lGiblI4ypmGtLlsA8/B+JbyHmimP74Sm/H83Z593BkSYgS6Ox58nWirIMoC/u
         kyj59nKfs9vNygTOo3NWKQ3XvRDv7ngTvUjxc=
Date: Thu, 2 Jul 2009 11:54:53 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (possibly
	caused by netem)
Message-ID: <20090702115453.GC7402@ff.dom.local>
References: <4A4A9DD6.8060800@anarazel.de> <4A4BAD5F.7050908@gmail.com> <4A4BD384.3090407@anarazel.de> <4A4C0144.5070203@anarazel.de> <20090702093031.GC4954@ff.dom.local> <20090702101207.GA7056@ff.dom.local> <4A4C95FC.7040305@anarazel.de> <4A4C9D75.5010300@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4C9D75.5010300@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 01:43:49PM +0200, Andres Freund wrote:
...
> I will start trying to place the issue by testing with existing kernels  
> between 2.6.30 and now.

If you can afford your time of course this would be very helpful.

Thanks,
Jarek P.
