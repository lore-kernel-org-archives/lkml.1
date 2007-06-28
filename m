Return-Path: <linux-kernel-owner+w=401wt.eu-S1762500AbXF1MJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762500AbXF1MJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbXF1MIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:08:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:13842 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbXF1MIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=QbZD9OEO8lcF7ApK37SdIryYKJjnQ92xcZdv/trIoETbVttU3h/UmFVk9014GmxwWcM1WRDn68uk7e6AiGkKu/SeoudHZt8Jm33dqw8Ap8lvP4eHKjyv5IzQx8xSHPf8ISvzOd0z+yKVb1v/Pg5KZ1m7CBEpz10MapOsjZZr0kc=
Message-ID: <4683A4D1.3000703@googlemail.com>
Date: Thu, 28 Jun 2007 14:08:49 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
>
>   

Compile error here.

...

Kernel: arch/i386/boot/bzImage is ready (#1)
ERROR: "check_signature" [drivers/input/misc/wistron_btns.ko] undefined!
ERROR: "check_signature" [drivers/block/xd.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


...

http://frugalware.org/~crazy/other/kernel/config


Regards,

Gabriel C

