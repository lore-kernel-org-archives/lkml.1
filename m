Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0BTU1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 15:27:19 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63438 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab0BTU1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 15:27:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DL8XNA+7JUeyMPfH1bCz192DUvmXVmMiB2YqjVfd1F3SBYeZjL3vwYZGfATZNNi+JT
         huKcSIS9hU7rh7AF2DB+C5aOyYFCk8MUqZpTUPRlkzwFZVep1CDa01As0e9iiSRJ2dIQ
         kcW+8+mduni5SiYW/kmu6SS8T+UvZhXlzqk98=
Subject: Re: [PATCH 0/14 V9] Work to enable SmartMedia/xD support in mtd
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
References: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 22:27:10 +0200
Message-ID: <1266697630.4152.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 23:49 +0200, Maxim Levitsky wrote: 
> This is slightly updated version of my patchset.
> Now I can tell you for sure that hotplug works.
> It was used/abused for long time.
> I did some changes in richoh card reader driver, to work better after resume
> and renamed it to r852.
> 
> I kindly ask you to merge this patchset to 2.6.34.
> If I/users find other bugs they can be addressed by follow up patches.
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> 
Should I expect at least some response on that?
Or not?

Best regards,
Maxim Levitsky

