Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZHGR2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZHGR2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZHGR2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:28:13 -0400
Received: from mail-bw0-f215.google.com ([209.85.218.215]:65346 "EHLO
	mail-bw0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZHGR2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ezrmkjOH6nSvZP/1FwhuKFGSF2+y123oLsrebGxN07jNWN5ZvTiYnYsFZQ8+w75w5Q
         nKAkGQQcixK3FQmz2BRjIDU0d2DQnEjwgIcP5t2QIvddDw+dFcCqnQrQ5re13x5zWKd0
         hwwnFcV6lfeQgQ/hbrLW8N0NWoXkspK029QIs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Fri, 7 Aug 2009 19:27:36 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-00246-g90bc1a6; KDE/4.2.4; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200907011835.27586.bzolnier@gmail.com> <200908071355.21648.bzolnier@gmail.com> <20090807.090158.45976865.davem@davemloft.net>
In-Reply-To: <20090807.090158.45976865.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908071927.36367.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009 18:01:58 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Fri, 7 Aug 2009 13:55:21 +0200
> 
> > On Wednesday 01 July 2009 22:47:29 David Miller wrote:
> >> Will get to it before the end of the weekend.
> >> 
> >> If I fail or abort, I'll integrate your version of the fix Bart, don't
> >> worry :)
> > 
> > Not that I'm worried but just out of curiosity..
> > 
> > Could you please tell me which week/month/year are we talking about here?
> 
> I became busier than I expected here in New York :-)

I would say that this is a bit unprofessional attitude which normally
is not accepted by PNAELV people.. :-)

> Actually both patches #4 and #5 are in my ide-next-2.6 tree, I just
> need to publish it out to kernel.org and update the patchwork status
> on these patches.

Are you trying to tell me that after 6 weeks there is still no public
tree to hold future IDE changes?

If this is indeed a case here I hope that it will get addressed ASAP.
