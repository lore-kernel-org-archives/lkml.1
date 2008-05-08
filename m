Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYEHAPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYEHAPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYEHAOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:14:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:54492 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYEHAOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=phGy2jHxnvhwjaUoVXJ8WefVs/db1dBuH5WLKk8FPzMbf0uB2K+bB53pVpyf11w0HCQKjGCdmBt1VQLV3dAZKd84NniwVpefDHvYhN3bX6d7diMJZmthTcj3cZs0sWiCgnWNL9pUhMc9no3a6rHTnuynf+6QX1ggduozvt3ZThU=
Message-ID: <9929d2390805071714t6497de7fwf177e0c82ee62772@mail.gmail.com>
Date: Wed, 7 May 2008 17:14:42 -0700
From: "Jeff Kirsher" <tarbal@gmail.com>
To: "Auke Kok" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] [MAINTAINERS] New maintainer for Intel ethernet adapters
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       greg@kroah.com
In-Reply-To: <20080507204233.12837.92852.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080507204233.12837.92852.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 1:42 PM, Auke Kok <auke-jan.h.kok@intel.com> wrote:
> I'm handing over maintainership to Jeff Kirsher and moving on
>  to other Linux/Open Source work within Intel. Good luck to Jeff ;)
>
>  Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

    Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

>  ---
>
>   MAINTAINERS |    6 ++----
>   1 files changed, 2 insertions(+), 4 deletions(-)
>
>  diff --git a/MAINTAINERS b/MAINTAINERS
>  index c3a533d..0cc47b9 100644
>  --- a/MAINTAINERS
>  +++ b/MAINTAINERS
>  @@ -2104,12 +2104,10 @@ L:      netdev@vger.kernel.org
>   S:     Maintained
>
>   INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)
>  -P:     Auke Kok
>  -M:     auke-jan.h.kok@intel.com
>  -P:     Jesse Brandeburg
>  -M:     jesse.brandeburg@intel.com
>   P:     Jeff Kirsher
>   M:     jeffrey.t.kirsher@intel.com
>  +P:     Jesse Brandeburg
>  +M:     jesse.brandeburg@intel.com
>   P:     Bruce Allan
>   M:     bruce.w.allan@intel.com
>   P:     John Ronciak
