Return-Path: <linux-kernel-owner+w=401wt.eu-S935908AbXGMG67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935908AbXGMG67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935765AbXGMG61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:58:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:8453 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935753AbXGMG6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:58:25 -0400
X-IronPort-AV: i="4.16,536,1175486400"; 
   d="scan'208"; a="34798254:sNHT23314837"
Subject: Re: Linux 2.6.22.1
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Chris Wright <chrisw@sous-sol.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bryan Wu <bryan.wu@analog.com>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Nish Aravamudan <nish.aravamudan@gmail.com>
In-Reply-To: <20070713065109.GD4306@sequoia.sous-sol.org>
References: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com>
	 <1184307380.8943.7.camel@roc-desktop> <20070713061617.GA24317@kroah.com>
	 <1184308100.8943.12.camel@roc-desktop>
	 <alpine.LFD.0.999.0707122328340.20061@woody.linux-foundation.org>
	 <20070713065109.GD4306@sequoia.sous-sol.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Fri, 13 Jul 2007 14:58:08 +0800
Message-Id: <1184309888.6158.1.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 13 Jul 2007 06:58:24.0477 (UTC) FILETIME=[34D8F0D0:01C7C51B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 23:51 -0700, Chris Wright wrote:
> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > In that case, it's almost certainly that that tree isn't doing the proper 
> > "git update-server-info" when people push to it.
> 
> Yup, should be fixed now.
> 
> thanks,
> -chris

Thanks a lot. With you guys help, it is  works.
- Bryan
