Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbXJEPfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbXJEPfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbXJEPfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:35:21 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:65019 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763241AbXJEPfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KVcbD6Tls4bLvpgBeb+TZdXeTFRTL6MpyPDLIEjq0N+FUEJw19uJbqskT9ujMDPR2opllLa1royOo6dubgxSfagfqMLKZpw8kib8Z3WcLnQF16Fef1MvHjxSJe33Ugi6SvSacJBsx6LLi1Uew6SCzBF+mEUoPO3C0bh2LqDokoM=
Message-ID: <8bd0f97a0710050835i39d2208ax78df01d41e80e7c7@mail.gmail.com>
Date: Fri, 5 Oct 2007 11:35:16 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Ralf Baechle" <ralf@linux-mips.org>
Subject: Re: [PATCH] Replace __attribute_pure__ with __pure
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>, aubrey.li@analog.com,
       bernd.schmidt@analog.com, bryan.wu@analog.com, grace.pan@analog.com,
       marc.hoffman@analog.com, michael.hennerich@analog.com,
       michael.frysinger@analog.com, jerry.zeng@analog.com,
       jie.zhang@analog.com, robin.getz@analog.com, roy.huang@analog.com,
       sonic.zhang@analog.com, vivi.li@analog.com, yi.li@analog.com,
       paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071005131309.GA445@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071005131309.GA445@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/07, Ralf Baechle <ralf@linux-mips.org> wrote:
> To be consistent with the use of attributes in the rest of the kernel
> replace all use of __attribute_pure__ with __pure and delete the
> definition of __attribute_pure__.
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

doesnt matter one way or the other to me, so:
Acked-by: Michael Frysinger <michael.frysinger@analog.com>

> And btw why does Analog list half their employees in the MAINTAINERS entry?
> Seems a little over the top ...

this is supposed to be replaced with just the mailing list
-mike
