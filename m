Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbXINQmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbXINQmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXINQmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:42:01 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:65367 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbXINQmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JD0hl7o1a6iJ0TwfhZ8l8LEJmeDCO4XjQJZfYjyj22+qbcgaa7YCFPONmdNkU13JMp2NIW9WHzUuhHPxCcfjRvy+qKd1OicPlg6JKkTYwjXox8OJUnbxpmxbyx/pqLYPgV2lC3ORLDqEJno4zQihO/h/iDgEOkqW449L993BiGw=
Message-ID: <a781481a0709140941w4ec76582j40ee53a189b99b05@mail.gmail.com>
Date: Fri, 14 Sep 2007 22:11:59 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
Subject: Re: [PATCH v3] Make the pr_*() family of macros in kernel.h complete
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, i2c@lm-sensors.org,
       linux-omap-open-source@linux.omap.com
In-Reply-To: <598D5675D34BE349929AF5EDE9B03E270155578C@az33exm24.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11896151802410-git-send-email-Emilian.Medve@Freescale.com>
	 <598D5675D34BE349929AF5EDE9B03E270155578C@az33exm24.fsl.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > -----Original Message-----
> > From: Medve Emilian-EMMEDVE1
> > Sent: Wednesday, September 12, 2007 11:40 AM
> > To: linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> > i2c@lm-sensors.org; linux-omap-open-source@linux.omap.com
> > Cc: Medve Emilian-EMMEDVE1

... no maintainer explicitly copied on the original mail who'd push this in.
Little thing, but LKML is too noisy, so you need to Cc: folks explicitly ...

> > Subject: [PATCH v3] Make the pr_*() family of macros in
> > kernel.h complete
> >
> > Other/Some pr_*() macros are already defined in kernel.h, but
> > pr_err() was defined
> > multiple times in several other places
> >
> > Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>

I think it's a useful cleanup, patch looks good to me ...

Reviewed-by: Satyam Sharma <satyam@infradead.org>

[ Original diff is at: http://lkml.org/lkml/diff/2007/9/12/182/1 ]
