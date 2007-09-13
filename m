Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbXIMM7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbXIMM7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXIMM7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:59:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:5709 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXIMM7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KmvampRNm4Ls9PgvsKpE6KcLQOdAJ52A7afhLbvffnKHzmSFEPn+USlSKNpccN7nl5K495i3pFZH93hlxWbsKC+rETcnDoiIlqzGb2rsGzsZkasgLjp0kqd9vNtgtiCrRGCAULU4qGuUpZlxOz4GABXCj5shCp8e+27ezgdpwZ4=
Message-ID: <6101e8c40709130559l69b87211k763c70a90d3d8221@mail.gmail.com>
Date: Thu, 13 Sep 2007 14:59:09 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [Sparc64 BUG] hangup under booting 2.6.22.X whith Sparc64
Cc: kovedi@gmail.com, linux-kernel@vger.kernel.org, "Greg KH" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070912.011103.41643890.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <406fe6c90709102233m2472e6c4h7d329a3f64692645@mail.gmail.com>
	 <20070911.083823.15264559.davem@davemloft.net>
	 <406fe6c90709120047g1cf0a995r391e9fe1fbac7101@mail.gmail.com>
	 <20070912.011103.41643890.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David!

On 9/12/07, David Miller <davem@davemloft.net> wrote:
> From: "Kövedi_Krisztián" <kovedi@gmail.com>
> Date: Wed, 12 Sep 2007 09:47:45 +0200
>
> > The patch work fine the kernel booting up without error messages.
>
> Thanks for testing.

this patch releated for 2.6.22.y too.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2cc7345ff71b27b5ac99e49ad7de39360042f601
we (Krisz and me) tested with 2.6.22.6, the server works and no errors
become for now.

-- 
Thanks,
Oliver
