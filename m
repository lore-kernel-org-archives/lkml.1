Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbZDQBat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbZDQBat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbZDQBaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:30:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:4259 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbZDQBai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jB27auqdAZ6Ph0kNROFiisv6jZS+rYx8136tAte976J+gGtbrJvxWG9oS9MJWqneGZ
         cFAPP7XEA+5BxhfD6+kGxtD9mravNTTjfjZdqIPxU6/rfqoaW+hrfW4uS3r0WaihDupv
         tloBv1gouE+4pzgmWQeaIZ37sYiH/XkDaoPTg=
MIME-Version: 1.0
In-Reply-To: <1239033288-3086-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1239033288-3086-1-git-send-email-anemo@mba.ocn.ne.jp>
Date: Thu, 16 Apr 2009 18:23:35 -0700
X-Google-Sender-Auth: 4b97977ee1523b34
Message-ID: <e9c3a7c20904161823j2cce3a6fpea95ba79ccf871a3@mail.gmail.com>
Subject: Re: [PATCH] DMA: TXx9 Soc DMA Controller driver (v2)
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 8:54 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> This patch adds support for the integrated DMAC of the TXx9 family.
>
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---

Just so you know I have not forgotten about this...  I have pulled
this version and integrated it into my cross-compile environment, so
far so good.  I will try to get you an Acked-by by tomorrow.

Ralf, I think I will leave the merge up to you.  As long as NET_DMA=n
and ASYNC_TX_DMA=n the chance for a regression is low, but it's your
call.

Regards,
Dan
