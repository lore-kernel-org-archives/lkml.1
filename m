Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbYELL3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbYELL3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYELL27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:28:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:8031 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbYELL26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:28:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PyWGLMNlG9muUdu4fJ7mHOP66kEJ0CzuHijaWaGjkSyigy0eY+q59vIcK4qtAtzwdcIM36WbuRxh96DUQOgP9nBytba0wch58pMzX4S/hyk3YSLrmxOrCw7tMJMYn8jLRTv7cZCjFwsIiCLVTRDxJY1ViQ0cR2ldJUgcJF/fyN0=
Message-ID: <c4e36d110805120428j4bf2bd79j790461a144e641ef@mail.gmail.com>
Date: Mon, 12 May 2008 13:28:58 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Compilation problem in drivers/media subdirectory
In-Reply-To: <c4e36d110805120420v28f78a29sf42f1a780c40d527@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110805120420v28f78a29sf42f1a780c40d527@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok I think my problem is fixed with fresh git-pull update  so my
report could be ignored,

Sorry for the noise

Zdenek


2008/5/12 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> Hello
>
>  For some time I've problem to compile my linux git tree  (even after
>  make mrproper)
>
>    ld -m elf_x86_64   -r -o drivers/built-in.o drivers/pci/built-in.o
>  drivers/video/built-in.o drivers/acpi/built-in.o
>  drivers/pnp/built-in.o drivers/char/built-in.o
>  drivers/serial/built-in.o drivers/base/built-in.o
>  drivers/block/built-in.o drivers/misc/built-in.o
