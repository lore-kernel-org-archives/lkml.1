Return-Path: <linux-kernel-owner+w=401wt.eu-S935302AbYBVNhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935302AbYBVNhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbYBVNhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:37:22 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:15951 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbYBVNhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:37:21 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com
In-Reply-To: <47BEAB48.7050900@nets.rwth-aachen.de>
References: <47BEAB48.7050900@nets.rwth-aachen.de>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 13:37:05 +0000
Message-Id: <1203687425.15721.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] let XEN depend on PAE
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=Y5ot43_3bogVCosib_oA:9 a=1JcAIhSMRSHmtbHnTzL1ZTY0nnAA:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-22 at 12:00 +0100, Arnd Hannemann wrote:
> As paravirtualized xen guests won't work with !X86_PAE, change the Kconfig
> accordingly.

Really? Xen guests should work on non-PAE if you have a non-PAE
hypervisor (which most distros don't ship but which does exist).

Ian.

-- 
Ian Campbell
Current Noise: The Ocean - Mesoproterozoic - Calymmian - Lake Disappointment

"World domination.  Fast"
(By Linus Torvalds)

