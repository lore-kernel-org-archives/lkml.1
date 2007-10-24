Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXJXPX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXJXPX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbXJXPXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:23:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:1728 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbXJXPXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KimnhTcXrqFjSgUC/QJZzUWCFRjYyQ84aoxNA0fj6G14K9hfMNRzJ6x1WJrHg8a5htNaW3AFwYNcDYoO1zILA0Iv2TqgoQQ6j7hgVk2SeYgT/iyhR3Iy/U9233RB34vVRE6FTfCLTaPlXWf9fkNDUARJoZHdu7qczg7lCpMl/io=
Message-ID: <8bd0f97a0710240823s7b28a30dt5e955d482a184053@mail.gmail.com>
Date: Wed, 24 Oct 2007 11:23:06 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Ralf Baechle" <ralf@linux-mips.org>
Subject: Re: [PATCH] Remove inclusions of <linux/autoconf.h>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071024145109.GA9535@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024145109.GA9535@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Ralf Baechle <ralf@linux-mips.org> wrote:
> Nothing should ever include this file.
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>
>  arch/blackfin/mach-common/interrupt.S |    1 -
>  arch/blackfin/mm/blackfin_sram.c      |    1 -

sounds good, thanks
-mike
