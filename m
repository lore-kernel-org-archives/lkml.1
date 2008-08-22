Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYHVDo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYHVDo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYHVDoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:44:18 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:19154 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYHVDoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IRApauBjzcq+GuNUDSl1XtLEzhefB2MjIThUwL3taaBIn1LaOuC3OAYYYQSi7P/bPA
         CaHLTmvdeGQ0s9Amri4/Gst+fSEU4MVd9RASsofvlExIRKF44ut9arrphQK94jXTVm/F
         /Zil0z6JSRX0W9HbAfI0BMT9Po7xQSoyNtrOQ=
Message-ID: <386072610808212044t60e1d897m33837ffe6d01408@mail.gmail.com>
Date: Fri, 22 Aug 2008 11:44:16 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [2.6 patch] m68knommu: let PCI depend on BROKEN
Cc: "Adrian Bunk" <bunk@kernel.org>, gerg@uclinux.org,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20080819150502.GA8318@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080819134718.GH8852@cs181140183.pp.htv.fi>
	 <20080819150502.GA8318@parisc-linux.org>
X-Google-Sender-Auth: a7afcd3954c6a065
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:05 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Aug 19, 2008 at 04:47:18PM +0300, Adrian Bunk wrote:
>> There exists blackfin hardware with PCI support, but the support
>               ^^^^^^^^
> m68knommu

I will take care of Blackfin parts.

>> currently in the kernel fails to build starting with:
>
> Hopefully someone fixes it instead of just acking this patch.
>

Sorry for the delay, I was out on my vacation this week.

Thanks all
-Bryan
