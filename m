Return-Path: <linux-kernel-owner+w=401wt.eu-S965397AbXCFRpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397AbXCFRpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965400AbXCFRpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:45:23 -0500
Received: from mail.tmr.com ([64.65.253.246]:58880 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965397AbXCFRpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:45:22 -0500
Message-ID: <45EDA8EE.1060308@tmr.com>
Date: Tue, 06 Mar 2007 12:46:22 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] the scheduled removal of OBSOLETE_OSS options
References: <20070305014956.GE3441@stusta.de>
In-Reply-To: <20070305014956.GE3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the scheduled removal of the OBSOLETE_OSS options 
> for 2.6.22.
> 
If these are drivers for which there are thought to be useful ALSA 
drivers, would it be reasonable to leave a stub for a help file naming 
the driver which claims to support the hardware?

I'm not objection to the removal of the drivers, just noting that 
identifying the new drivers can be made easier.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
