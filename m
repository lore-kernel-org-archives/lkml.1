Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbYEXG04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbYEXG04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 02:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYEXG0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 02:26:49 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:31706 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbYEXG0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 02:26:47 -0400
Message-ID: <fa686aa40805232326w35f455d1s274899160d47eccb@mail.gmail.com>
Date: Sat, 24 May 2008 00:26:46 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       fabrizio.garetto@gmail.com
In-Reply-To: <200805221905.32288.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
	 <20080521151928.GA28857@polina.dev.rtsoft.ru>
	 <200805221905.32288.david-b@pacbell.net>
X-Google-Sender-Auth: fe1f9f94aa2388ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 8:05 PM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 21 May 2008, Anton Vorontsov wrote:
>> > +++ b/drivers/spi/spi_of.c
>>
>> I think better placement for this is drivers/of, no?
>
> Yes please.

Okay, I wasn't sure.  Will do.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
