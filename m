Return-Path: <linux-kernel-owner+w=401wt.eu-S935942AbXGRSKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935942AbXGRSKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934340AbXGRSKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:10:04 -0400
Received: from il.qumranet.com ([82.166.9.18]:60141 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934108AbXGRSKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:10:02 -0400
Message-ID: <469E5777.9060405@qumranet.com>
Date: Wed, 18 Jul 2007 21:09:59 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] Use standard CR8 flags, and fix TPR definition
References: <1184677946.10380.4.camel@localhost.localdomain>	 <1184678060.10380.7.camel@localhost.localdomain>	 <1184678129.10380.10.camel@localhost.localdomain>	 <1184678171.10380.12.camel@localhost.localdomain>	 <1184678216.10380.14.camel@localhost.localdomain>	 <1184678275.10380.16.camel@localhost.localdomain>	 <1184678348.10380.19.camel@localhost.localdomain>	 <1184679175.10380.25.camel@localhost.localdomain>	 <1184679256.10380.27.camel@localhost.localdomain> <1184679437.10380.31.camel@localhost.localdomain> <469CE79D.7030001@zytor.com>
In-Reply-To: <469CE79D.7030001@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 18 Jul 2007 21:09:59 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Rusty Russell wrote:
>   
>> Intel manual (and KVM definition) say it's TPR is 4 bits wide.  Also fix
>> CR8_RESEVED_BITS typo.
>>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>     
>
> Indeed it is.
>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
>
>   

Applied-by: Avi Kivity <avi@qumranet.com>

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

