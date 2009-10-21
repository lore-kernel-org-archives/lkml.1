Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZJUOpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZJUOpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZJUOpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:45:21 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:58488 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZJUOpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <20091021131747.GG12819@pengutronix.de>
References: <20090618025030.12363.69402.stgit@localhost.localdomain> 
	<20091021131747.GG12819@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Oct 2009 23:45:05 +0900
X-Google-Sender-Auth: 2f817e653fd95a38
Message-ID: <fa686aa40910210745l7d19d6ecq303ee990bed82c62@mail.gmail.com>
Subject: Re: [PATCH v4] powerpc/5200: Add mpc5200-spi (non-PSC) device driver
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linuxppc-dev@ozlabs.org, David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 10:17 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi Grant,
>
> On Wed, Jun 17, 2009 at 08:55:01PM -0600, Grant Likely wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
>>
>> Adds support for the dedicated SPI device on the Freescale MPC5200(b)
>> SoC.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>
> do you have an updated version to share? Or is V4 still 'status quo'?

V4 was supposed to go in during the merge window.  But I haven't heard
anything from David (and I didn't pursue it either).  Unless David
objects, I'll put it into either my -merge or my -next tree; depending
on what Ben and Linus prefer.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
