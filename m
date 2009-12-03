Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbZLCHKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbZLCHKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZLCHKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:10:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:33410 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZLCHKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:10:16 -0500
Date: Thu, 3 Dec 2009 07:10:00 +0000 (GMT)
From: David Woodhouse <dwmw2@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: linux-mips@linux-mips.org, Thomas Koeller <thomas.koeller@baslerweb.com>,
       Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH] eXcite: Remove platform support and drivers.
In-Reply-To: <20091202153534.GA10692@linux-mips.org>
Message-ID: <alpine.LFD.2.00.0912030709230.10116@macbook.infradead.org>
References: <20091202153016.GA9892@linux-mips.org> <20091202153534.GA10692@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Ralf Baechle wrote:

> The platform has never been fully merged.  Remove it including MTD and
> watchdog drivers.
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> ---
> I'd like acks from the watchdog and MTD maintainers please.

Acked-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
dwmw2

