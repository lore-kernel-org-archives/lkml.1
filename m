Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbYFCHWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbYFCHWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYFCHWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:22:03 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:52776 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYFCHWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:22:01 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-9.tower-164.messagelabs.com!1212477718!18371097!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Tue, 3 Jun 2008 09:21:55 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Greg KH <gregkh@suse.de>
CC: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UIO: generic platform driver
Message-ID: <20080603072155.GA11824@digi.com>
References: <20080520092312.GA10745@digi.com> <1211275482-11249-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1211275482-11249-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080520210844.GF3220@local> <20080526055818.GD8791@digi.com> <20080526060247.GA14453@suse.de> <20080530091631.GA1367@digi.com> <20080530163546.GA19603@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080530163546.GA19603@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 03 Jun 2008 07:21:56.0291 (UTC) FILETIME=[81052930:01C8C54A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Greg KH wrote:
> > > Yes, if everyone has finally agreed, Hans, can you resend them to me so
> > > I know what to apply, with you signed-off-by?
> > If Hans did that, I didn't notice it.  If you want to take the patches
> > from me you can pull them from my uio branch at
> > 
> > 	git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git uio
> > 
> > These have the Signed-off-by: by Hans, too.
> 
> Hans is at LinuxTag this week and said he would send them to me when he
> got back.  So I'll wait for his copies,
OK.

>                                         I'd prefer not to pull from git,
> as that doesn't really work well with my patchflow process.
I know you work with quilt, but I thought it to be no problem for you to
extract the patches from my tree into your quilt queue.  I'll remember
that for the future. :-)

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
