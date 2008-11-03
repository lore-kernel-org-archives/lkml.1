Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbYKCNzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbYKCNzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYKCNy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:54:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:15953 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYKCNy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:54:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kJrgQl3WyUu2ujz/DkTeGztTEEi18NULC08LF6H4Yw+900oJnBjwol8UpjgxLsnWtH
         pte2RiyUOON0PQcH0MRH5tczbxWi4Z90ytcf8X7bFkluTQ0yFVdiGOeoHU4nHJPMdePt
         840NpvCYVuHrt40OO9cqwRfr7jglrTT0E5a6s=
Date: Mon, 3 Nov 2008 16:58:14 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com
Subject: next-20081103: error: asm/ftrace.h: No such file or directory
Message-ID: <20081103135814.GB3432@x200.localdomain>
References: <20081103183214.aac32543.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103183214.aac32543.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alpha is busted:

  CC      init/main.o
In file included from include/linux/interrupt.h:12,
                 from include/linux/rtc.h:102,
                 from include/linux/efi.h:19,
                 from init/main.c:45:
include/linux/hardirq.h:8:24: error: asm/ftrace.h: No such file or directory
