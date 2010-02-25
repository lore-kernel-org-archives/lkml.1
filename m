Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab0BYFPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 00:15:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:34641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab0BYFPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 00:15:40 -0500
Message-ID: <4B8609CE.5000705@kernel.org>
Date: Thu, 25 Feb 2010 14:25:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, hancockrwd@gmail.com,
       david-b@pacbell.net, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
References: <4B7CAF95.6020306@gmail.com> <SNT125-W36AFF0BF953EABAC9A0432C3400@phx.gbl> <4B85EE88.5050506@kernel.org> <201002250503.09327.oliver@neukum.org>
In-Reply-To: <201002250503.09327.oliver@neukum.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 05:15:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2010 01:03 PM, Oliver Neukum wrote:
> Am Donnerstag, 25. Februar 2010 04:29:12 schrieb Tejun Heo:
>> Arghhh.... I hate when intel pulls this type of 'product
>> differentiation' stunts.  At any rate, I'm doubtful swiotlb'ing for
>> usb2.0 would be noticeable at all.
> 
> That can and should be tested.

Robert did already.  Given that USB2.0 devices aren't usually used for
high-perf storage subsystem, the benefit looks marginal to me but
everyone is entitled to own opinion.

Thanks.

Thanks.

-- 
tejun
