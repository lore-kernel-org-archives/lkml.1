Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbYCaOyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbYCaOyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYCaOyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:54:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:51387 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYCaOym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ggWSQJiaprSprF/sCHtvj9zHNj2b4qsYh0+KcwErLIOi24sMzQF5LKLIcARt8KjZ+RmQBOqCJNxF/riqw6WxWGtmQxTvmja2OZgPYjn4T9gMcQfXFnvGL9V5K4wMA6Lu5ViY0/q2twqUAzuKt9fBZVlVn6VEcnzdeYDIjfGtr7k=
Message-ID: <804dabb00803310754q40eaca5ai8b9faacecef0edef@mail.gmail.com>
Date: Mon, 31 Mar 2008 22:54:41 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Jacek Luczak" <difrost.kernel@gmail.com>
Subject: Re: RFC: Writing Solaris Device Drivers in Java
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
In-Reply-To: <47F0D201.6030102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F0491F.4050804@gmail.com> <1206959293.8514.636.camel@twins>
	 <47F0D201.6030102@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 7:58 PM, Jacek Luczak <difrost.kernel@gmail.com> wrote:
> Peter Zijlstra pisze:
>  >
>  Java? Compete against C? Don't scare embedded devs.
>

The future is always uncertain for us.   Embedded development usually
emphasizes on performance, unlike those of the desktop.   So which
language will be king tomorrow in embedded, it boils down to
performance + optimization + ease of development.   Just imagine:
from 10 lines of C reduced to 2 lines of XXX-based language software -
I think the 10 lines will scare off the embedded developers of
tomorrow.    I may be wrong :-).

-
Regards,
Peter Teoh
