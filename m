Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYJUB62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYJUB62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYJUB6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:58:10 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:15901 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYJUB6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SCjABMfdIWIdWCGF5UAV2GFCT8NrEDg5KkeAxVubHqEYQGzqWwoO0O2ThOLEdTAQjo
         Myg7HAaxvHTeMOMAdo9PBTObvFGSM+6oDgu6sl/JSCu3QNeJoaQLYD4qOgLHQ8dYKVij
         MYxOdWNvLl2CXu3yfFX/G8MFlPWu6YM3MZPqQ=
Message-ID: <9929d2390810201858m39cd46demfc6b61f81a93650f@mail.gmail.com>
Date: Mon, 20 Oct 2008 18:58:06 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH 1/3] Add file patterns to MAINTAINERS
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@osdl-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Pavel Machek" <pavel@suse.cz>,
       "=?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?=" <ukleinek@strlen.de>
In-Reply-To: <1224541704-30357-2-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224541704-30357-1-git-send-email-joe@perches.com>
	 <1224541704-30357-2-git-send-email-joe@perches.com>
X-Google-Sender-Auth: c6f09e47e3b01759
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 3:28 PM, Joe Perches <joe@perches.com> wrote:
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
>  INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)
>  P:     Jeff Kirsher
>  M:     jeffrey.t.kirsher@intel.com
>  P:     Jesse Brandeburg
>  M:     jesse.brandeburg@intel.com
>  P:     Bruce Allan
>  M:     bruce.w.allan@intel.com
>  P:     PJ Waskiewicz
>  M:     peter.p.waskiewicz.jr@intel.com
>  P:     John Ronciak
>  M:     john.ronciak@intel.com
>  L:     e1000-devel@lists.sourceforge.net
>  W:     http://e1000.sourceforge.net/
>  S:     Supported
> +F:     drivers/net/e100.c
> +F:     drivers/net/e1000/
> +F:     drivers/net/ixgb/
>

Your missing

drivers/net/e1000e/
drivers/net/igb/
drivers/net/ixgbe/

for the INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)

-- 
Cheers,
Jeff
