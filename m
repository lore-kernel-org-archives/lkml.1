Return-Path: <linux-kernel-owner+w=401wt.eu-S938907AbXG3Ghn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938907AbXG3Ghn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937850AbXG3Ghg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:37:36 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:43345 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765141AbXG3Ghf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:37:35 -0400
X-IronPort-AV: i="4.19,197,1183348800"; 
   d="scan'208"; a="35938503:sNHT24111689"
Subject: Re: [PATCH] Blackfin: Remove duplicate inclusion of linux/irq.h
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Aidan Williams <aidan@nicta.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
In-Reply-To: <8bd0f97a0707292333p7428f1f7l1a4bd41993592826@mail.gmail.com>
References: <200707292348.25880.jesper.juhl@gmail.com>
	 <8bd0f97a0707292333p7428f1f7l1a4bd41993592826@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 30 Jul 2007 14:45:13 +0800
Message-Id: <1185777913.22473.4.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 30 Jul 2007 06:37:34.0077 (UTC) FILETIME=[1C92CAD0:01C7D274]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 02:33 -0400, Mike Frysinger wrote:
> On 7/29/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > arch/blackfin/mach-bf548/boards/ezkit.c includes linux/irq.h twice.
> > This patch removes the duplicate.
> 
> thanks, but we've fixed this in our tree already, we just havent
> pushed it to linux mainline
> -mike

Yes, Thank you Jesper.

As Mike said, it will be merged later for mailine.

-Bryan
