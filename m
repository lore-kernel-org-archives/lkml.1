Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbXEaEdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbXEaEdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEaEcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:32:54 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:28033 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbXEaEcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:32:53 -0400
X-IronPort-AV: i="4.14,596,1170651600"; 
   d="scan'208"; a="40605520:sNHT33981336949"
Subject: Re: [PATCH] [RAMFS NOMMU]: a bug in ramfs_nommu_resize function,
	passing old size to vmtruncate
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bryan.wu@analog.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20070530211859.355172e2.akpm@linux-foundation.org>
References: <1180582315.10836.2.camel@roc-laptop>
	 <1180582528.10836.6.camel@roc-laptop>
	 <alpine.LFD.0.98.0705302054380.26602@woody.linux-foundation.org>
	 <1180584202.6363.6.camel@roc-laptop>
	 <20070530211859.355172e2.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 31 May 2007 12:27:08 +0800
Message-Id: <1180585628.6363.9.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 21:18 -0700, Andrew Morton wrote:
> On Thu, 31 May 2007 12:03:22 +0800 Bryan Wu <bryan.wu@analog.com> wrote:
> 
> > W: unable to extract a valid address from: torvalds@linux-foundation.org akpm@linux-fundation.org linux-kernel@vger.kernel.org
> 
> Maybe it didn't like the "fundation" typo.
> -

Oh, I input this Warning message in my Laptop Evolution. It is right on
my Desktop git-send-email. -:)))

Thanks
-Bryan

> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
