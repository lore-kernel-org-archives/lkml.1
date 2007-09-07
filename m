Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbXIGXsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbXIGXsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXIGXsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:48:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:35470 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbXIGXsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rXhr1D5Z/Vlg64c18oX8Ml7o+KeSD3con6YwzFaNBMlCKCeC/gvdakTN2zmuOZ64uVsWO+Tfv16YDdBR8RyPKcMdckeIjh+sQ+1yQ9oDUzvNmYHCN8VvQO0lpdufpfp77YAc6+wqyVRp2saoy855RkKqKX01R0WmAzmscryvCpI=
Message-ID: <6bffcb0e0709071648y3e18fe23s24fdff3923690448@mail.gmail.com>
Date: Sat, 8 Sep 2007 01:48:36 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Mark Nipper" <nipsy@bitgnome.net>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference<1>
Cc: linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
In-Reply-To: <20070907052720.GA3122@king.bitgnome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070907052720.GA3122@king.bitgnome.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

[Adding netdev to CC]

On 07/09/2007, Mark Nipper <nipsy@bitgnome.net> wrote:
>         I've received two oopses now from my kernel while running
> the 2.6.22 series.  The first was with 2.6.22.1 back in July and
> the second which happened just within the last day is 2.6.22.5.
> They both appear to be the same bug and I don't think it's
> hardware related.  I'm attaching the entries from logcheck which
> I received when they happened.
>
>         I'm not subscribed to the mailing list, so please make
> sure to copy me directly on any replies.  And let me know if
> anyone needs any additional information to try to track this
> down.  Thanks for reading...

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
