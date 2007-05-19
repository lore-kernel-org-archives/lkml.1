Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbXESJER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbXESJER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 05:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbXESJEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 05:04:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:36644 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbXESJEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 05:04:05 -0400
Subject: Re: [PATCH/WIP] Remove 'irq' argument from all IRQ handlers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <464E9739.40909@garzik.org>
References: <464E9739.40909@garzik.org>
Content-Type: text/plain
Date: Sat, 19 May 2007 19:03:57 +1000
Message-Id: <1179565437.32247.477.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 02:20 -0400, Jeff Garzik wrote:
> 
> Before I will even consider submitting this upstream, this patchset
> needs
> 
> * non-x86[-64] build fixes, and testing
> * update the Mac drivers

Which ones ? I don't remember doing much of irq either... could be some
drivers we share with m64k or some historical stuff... should be easy
enough to fix in any case.

Overall, sounds like a good idea to me.

Cheers,
Ben.

