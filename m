Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbZAOKKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbZAOKKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZAOKKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:10:07 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:15107 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZAOKKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:10:06 -0500
Date: Thu, 15 Jan 2009 11:09:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_MFD_PCF50633=m breaks the kernel build
Message-ID: <20090115110955.4a8e9c5b@hyperion.delvare>
In-Reply-To: <20090115091107.GB3199@fedora.yogi>
References: <20090115100653.509416fb@hyperion.delvare>
	<20090115091107.GB3199@fedora.yogi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 14:41:08 +0530, Balaji Rao wrote:
> On Thu, Jan 15, 2009 at 10:06:53AM +0100, Jean Delvare wrote:
> > Hi Balaji,
> > 
> > Building kernel 2.6.29-rc1-git4 on x86_64 with CONFIG_MFD_PCF50633=m
> > fails at linking time with:
> > 
> > ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> > ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
> 
> Yes, I've seen this. The fix is waiting on linux-mfd to be pulled
> anytime soon.

Where is linux-mfd? And what is it, a git tree, a mailing list? I
couldn't find any reference.

Can you please send me the patch now, so that I can fix my build
locally right now?

Thanks,
-- 
Jean Delvare
