Return-Path: <linux-kernel-owner+w=401wt.eu-S937139AbXFGVdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937139AbXFGVdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935198AbXFGVcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:32:47 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.7]:2904 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935055AbXFGVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:32:46 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Date: Thu, 7 Jun 2007 22:32:36 +0100
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
References: <20070607162251.5f291325@the-village.bc.nu> <m3wsyfzcpt.fsf@maximus.localdomain>
In-Reply-To: <m3wsyfzcpt.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706072232.37051.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007 22:17:18 Krzysztof Halasa wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > The intel-rng printed a nice well formatted message when the port was
> > disabled. Someone then came along and blindly trashed it by screwing up a
> > trim down to 80 columns.
>
> Perhaps we should drop that 80-column style and use some 120+?
> X or no X, almost all people now have more lines and columns on their
> displays than MDA 20 years ago.
>
> 132 to match text VGA perhaps?
> 80 can be left for the actual _output_, I mean number of chars printed
> by kernel code.

I personally buy the argument that 80 cols helps remind people that they've 
used too many indentation depths and should redesign their code. I think it's 
a good thing to stick to where possible, even if just from a design 
perspective.

There are some cases such as the one Alan has pointed out here where being 
strictly 80 cols seems more destructive than useful, but those are the 
exception, not the rule (IMO).

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
