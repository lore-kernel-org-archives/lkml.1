Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYE3JQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYE3JQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYE3JQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:16:40 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:37388 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYE3JQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:16:39 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-29.messagelabs.com!1212138998!13420017!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Fri, 30 May 2008 11:16:31 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Greg KH <gregkh@suse.de>
CC: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UIO: generic platform driver
Message-ID: <20080530091631.GA1367@digi.com>
References: <20080520092312.GA10745@digi.com> <1211275482-11249-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1211275482-11249-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080520210844.GF3220@local> <20080526055818.GD8791@digi.com> <20080526060247.GA14453@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080526060247.GA14453@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 30 May 2008 09:16:34.0898 (UTC) FILETIME=[DB564B20:01C8C235]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Greg KH wrote:
> On Mon, May 26, 2008 at 07:58:18AM +0200, Uwe Kleine-K?nig wrote:
> > Hello,
> > 
> > Hans J. Koch wrote:
> > > On Tue, May 20, 2008 at 11:24:42AM +0200, Uwe Kleine-K?nig wrote:
> > > > Signed-off-by: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
> > > 
> > > Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> > I assume now these two patches are ready go into mainline?!  What's the
> > next step?  Greg, do you take them into your driver tree?
> 
> Yes, if everyone has finally agreed, Hans, can you resend them to me so
> I know what to apply, with you signed-off-by?
If Hans did that, I didn't notice it.  If you want to take the patches
from me you can pull them from my uio branch at

	git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git uio

These have the Signed-off-by: by Hans, too.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
