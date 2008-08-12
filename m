Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYHLLMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYHLLMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 07:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYHLLMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 07:12:12 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:34086 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYHLLMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 07:12:12 -0400
Subject: Re: [PATCH 00/11] fsl_usb2_udc: A number of bug fixes and cleanups.
From: Li Yang <leoli@freescale.com>
Reply-To: leoli@freescale.com
To: Will Newton <will.newton@gmail.com>, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Jiang Bo <tanya.jiang@freescale.com>
In-Reply-To: <87a5b0800808080313p1e20f956m5776bfde1e139c69@mail.gmail.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
	 <989B956029373F45A0B8AF0297081890027C4EC2@zch01exm26.fsl.freescale.net>
	 <87a5b0800808080313p1e20f956m5776bfde1e139c69@mail.gmail.com>
Content-Type: text/plain
Organization: Freescale Semiconductor
Date: Tue, 12 Aug 2008 19:27:30 +0800
Message-Id: <1218540450.9410.7.camel@Gundam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2008 11:12:06.0470 (UTC) FILETIME=[4171BE60:01C8FC6C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 18:13 +0800, Will Newton wrote:
> On Thu, Jul 17, 2008 at 10:43 AM, Li Yang <LeoLi@freescale.com> wrote:
> >> -----Original Message-----
> >> From: Will Newton [mailto:will.newton@imgtec.com]
> >> Sent: Tuesday, July 15, 2008 11:25 PM
> >> To: linux-kernel@vger.kernel.org
> >> Cc: linux-usb@vger.kernel.org; Li Yang; Jiang Bo;
> >> gregkh@suse.de; Will Newton
> >> Subject: [PATCH 00/11] fsl_usb2_udc: A number of bug fixes
> >> and cleanups.
> >>
> >> From: Will Newton <will.newton@gmail.com>
> >>
> >> Hi,
> >>
> >> These patches fix a couple of small bugs and cleanup parts of
> >> the fsl_usb2_udc USB gadget driver. I've split them up quite
> >> finely for ease of reviewing and to separate functional
> >> changes. Any comments would be appreciated.
> >>
> >> I would also appreciate it if someone with real Freescale
> >> hardware could test these changes, I'm testing this driver
> >> with a different SoC containing the same TDI/ARC/ChipIdea IP block.
> >
> > Thanks for the patches.  Looks like they are ok, but I still need to
> > test them later.
> 
> Hi Leo,
> 
> Have you had a chance to test these patches yet?
> 
Yes, they are working fine.

Acked-by: Li Yang <leoli@freescale.com>

- Leo

