Return-Path: <linux-kernel-owner+w=401wt.eu-S1030589AbXBMA1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030589AbXBMA1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXBMA1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:27:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:12517 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030589AbXBMA07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:26:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l+pFBV+2g5Vjx1ZZTUhkTWqNCdouQzwNxrFmhE6m43ucatLf3iVN0dSbJoRIB9egxQt6cufUFa7Z8jVizJLs/sMNFS73am5T5WYcI3xp8ro74vA7H8zY3PcbcSqLDxyBZQEiRvAc3Th+9S+C/HNUKzzjQ/d97EzlozCLAZPmuO8=
Message-ID: <12c511ca0702121626u7a100671w2e684dd5845d1220@mail.gmail.com>
Date: Mon, 12 Feb 2007 16:26:57 -0800
From: "Tony Luck" <tony.luck@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: build error: allnoconfig fails on mincore/swapper_space
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <45D0F2F8.7060602@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
	 <20070212150802.f240e94f.akpm@linux-foundation.org>
	 <45D0F2F8.7060602@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > oops.  CONFIG_SWAP=n,  I assume?
>
> Yes, sorry.  Full config attached.

<metoo>Same breakage on "make allnoconfig" for ia64</metoo>
