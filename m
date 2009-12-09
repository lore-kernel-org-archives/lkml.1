Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZLIGPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZLIGPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZLIGPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:15:30 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:60235 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZLIGPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:15:30 -0500
MIME-Version: 1.0
In-Reply-To: <20091208163546.3354a7f5.akpm@linux-foundation.org>
References: <20091208211258.GA13706@pengutronix.de> <20091208153239.af0b5bb8.akpm@linux-foundation.org> 
	<fa686aa40912081625y3750a7fegbac38926182e38c6@mail.gmail.com> 
	<20091208163546.3354a7f5.akpm@linux-foundation.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 8 Dec 2009 23:15:12 -0700
X-Google-Sender-Auth: fd4cb4ec622e87dd
Message-ID: <fa686aa40912082215l30f0b843ve891d27648c24526@mail.gmail.com>
Subject: Re: [PATCH 0/5] spi-imx: some updates
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>,
       =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       spi-devel-general@lists.sourceforge.net,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 5:35 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 8 Dec 2009 17:25:59 -0700
> Grant Likely <grant.likely@secretlab.ca> wrote:
>
>> I'm new to the job, so I'm being cautions about which things I'm pick
>> up.  However, I'll happily merge anything that Andrew says is okay.
>
> oop.  If I'm going to send a patch to a subsystem maintainer I'll usually give
> it less attention than the ones I plan to merge myself.
>
> Oh well, at least this way people will get their patches merged easily ;)

Hmmm... maybe I'll be more selective then.

I've also got JH to set up a patchwork page for SPI so that I won't
drop anything on the floor.  I could certainly use some help with
triaging & acking the stuff in there.  Anyone want to volunteer?

>> Andrew, when in the merge window do you typically send out patch
>> queues?
>
> Late.  I stage the -mm patches after linux-next so I spend most of the
> merge window waiting for people to get their stuff into mainline.

Okay, thanks.

> Often there are stragglers who I need to route around.  It's usually
> not a significant problem though.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
