Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab0CMD66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:58:58 -0500
Received: from mail-pz0-f200.google.com ([209.85.222.200]:42316 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab0CMD65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 22:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=HDwxFNsVORyGSo0U3gBr46GZau3iFztYoXfNaujVLHYB6V1uYCFx2nCkD/I06JWpt9
         TuaBf7ofKPc4trzBOHJ2PCj6P708gxZR7VftnDvuCR9Z72GX8frz8M3ixFPc2h0OQn97
         iseBBZTvZwJg2bO17xg8k0dhITRfzIWguUAyM=
Subject: Re: [PATCH 1/3] Loongson-2F: Flush the branch target history such
 as BTB and RAS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Shinya Kuribayashi <shinya.kuribayashi@necel.com>,
       Greg KH <gregkh@suse.de>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100311095944.GC18065@linux-mips.org>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
	 <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>
	 <4B98632E.70806@necel.com>  <20100311095944.GC18065@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Sat, 13 Mar 2010 11:52:21 +0800
Message-ID: <1268452341.21443.3.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 10:59 +0100, Ralf Baechle wrote:
> On Thu, Mar 11, 2010 at 12:27:42PM +0900, Shinya Kuribayashi wrote:
> 
> > Are you sure that RAS represents "Row Address Strobe", not "Return
> > Address Stack?"

This should be Return Address Stack.

Will resend this patch later.

Thanks & Regards,
	Wu Zhangjin

