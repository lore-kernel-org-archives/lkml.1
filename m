Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbXCaClO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbXCaClO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXCaClO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:41:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:11898 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334AbXCaClN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D4nd2AaE+45kgXtK5YcBam0Bm5qW99p/ehR4BRuFF6IGB2y07BcIPH1mMkj4vbVXu03zvPdzI5pP9E66dEg0PGrgbJQvDO8+DwzXgqiZ7niR9WJ7V2wBtN9+Eq+8tcZ4QxjWFbEJKvcDCEfjcg3WqTibtHiQzGyvYk366QBBNj4=
Message-ID: <b6a2187b0703301941y5469560aq2e63730c6a93aa82@mail.gmail.com>
Date: Sat, 31 Mar 2007 10:41:12 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [4/4] 2.6.21-rc5: known regressions (v2)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "=?ISO-8859-1?Q?Fr=E9d=E9ric_Riss?=" <frederic.riss@gmail.com>,
       "Tino Keitel" <tino.keitel@gmx.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, pavel@suse.cz,
       linux-pm@lists.osdl.org, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       "Soeren Sonnenburg" <kernel@nn7.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Tejun Heo" <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070330214956.GQ14134@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <20070330214956.GQ14134@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/07, Adrian Bunk <bunk@stusta.de> wrote:

> Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
> References : http://lkml.org/lkml/2007/3/25/217
> Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> Status     : unknown

Still broken on.2.6.21-rc5.

Jeff.
