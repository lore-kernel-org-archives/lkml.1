Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbYCDJb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbYCDJb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYCDJbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:31:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:6878 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYCDJbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:31:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Zk1an9oShi0ooBrmv0NJVR5iv9Kfr+Vn8X4ggX8XLGH/U7qlirjgRdrDHjbiH0kjExhiJOP/TNGoBOUwgCFaL8khxy7S+lBbl1Xdtlu6eEJEX/LxiYIapSHTMQPpz8EvefQR9p0o1VLgpmwgVGxDAo9h90F/blGbTPD5wj0WD3o=
Message-ID: <47CD16D0.1020000@gmail.com>
Date: Tue, 04 Mar 2008 18:30:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: jens.axboe@oracle.com, tomof@acm.org,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>	<20080304085944.GG6704@kernel.dk>	<20080304180648W.fujita.tomonori@lab.ntt.co.jp> <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> OK, I've updated his patch. Tejun, can you audit this?

Looks good to me.

Thanks.

-- 
tejun
