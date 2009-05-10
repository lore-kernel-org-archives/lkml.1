Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZEJCcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZEJCcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 22:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbZEJCcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 22:32:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37675 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbZEJCcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 22:32:04 -0400
Date: Sun, 10 May 2009 03:32:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com
Subject: Re: [PATCH] dell-laptop : remove the duplicated kconfig option
Message-ID: <20090510023203.GC14018@srcf.ucam.org>
References: <a8e1da0905091928p40228e4ejdcf10a706c5b95b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0905091928p40228e4ejdcf10a706c5b95b7@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 10:28:39AM +0800, Dave Young wrote:

(Cc:ing Len)

> dell-laptop driver has duplicated Kconfig defination both in
> drivers/misc/Kconfig and drivers/platform/x86/Kconfig.
> 
> Here remove the drivers/misc/ option because its source code is under
> drivers/platform/x86.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
