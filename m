Return-Path: <linux-kernel-owner+w=401wt.eu-S1762805AbXGPGj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbXGPGj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXGPGjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:39:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:49145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbXGPGjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:39:46 -0400
Date: Mon, 16 Jul 2007 07:34:32 +0200
From: Stefan Seyfried <seife@suse.de>
To: Richard Hughes <hughsient@gmail.com>
Cc: Alexey Starikovskiy <aystarik@gmail.com>, Bill Davidsen <davidsen@tmr.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Zhang Rui <rui.zhang@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
Message-ID: <20070716053432.GA20102@suse.de>
References: <20070709145755.GD3492@stusta.de> <20070709174544.2a6b7067@the-village.bc.nu> <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr> <46951969.4030109@tmr.com> <4695BCEA.4060108@gmail.com> <1184231897.2380.2.camel@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1184231897.2380.2.camel@work>
X-Operating-System: openSUSE 10.3 (i586) Alpha5plus, Kernel 2.6.22-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 10:18:17AM +0100, Richard Hughes wrote:
> On Thu, 2007-07-12 at 09:32 +0400, Alexey Starikovskiy wrote:
> > >> [*] Does someone have an alternative for
> > >> /proc/acpi/battery/BAT1/{state,info}?
> > I'm working on it. Should have proto by the end of week.
> 
> If you are using the power_supply class (i hope you are ;-) then a HAL
> from freedesktop git should make userspace continue to just work.

Having to update HAL is not my definition of "does not break userspace".
And, BTW, there is more than just HAL out there using /proc/acpi, and
this should continue to work.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
