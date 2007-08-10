Return-Path: <linux-kernel-owner+w=401wt.eu-S935652AbXHJNRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935652AbXHJNRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbXHJNRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:17:07 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:50835 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbXHJNRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ic7WHrXETAwm+to+t9Bz+dlqmZTvNpKy3N9QDL5R7zhCR9gcJXo53dTPAmNJPm6MLL4n750C2txYUggYwK2Qss8g3x6NexJrGB1KvsLc0R1ZRb50Axtp/9KdPFrCh22RSyz3Ph5PFBLDHzp2JKoofZ3GooTVLO72MJu+wTM+sIo=
Message-ID: <851fc09e0708100617p2c2a7371y328c18e375f3a453@mail.gmail.com>
Date: Fri, 10 Aug 2007 21:17:04 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: EFI e820 map handling
Cc: "Huang, Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200708091206.37302.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708091206.37302.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Andi Kleen <ak@suse.de> wrote:
> I thought a bit about the zero page problem. I really would prefer to not
> having it used in a boot loader right now because it's not extensible anymore
> when external users start (ab)using it.

I think there is more to be discussed than just EFI->e820 conversion.
We can discuss them in another thread.

Best Regards,
Huang Ying
