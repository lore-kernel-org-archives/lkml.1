Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYHLNAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYHLNAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYHLNA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:00:26 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:48435 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbYHLNA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:00:26 -0400
Date: Tue, 12 Aug 2008 15:58:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] WATCHDOG: don't auto-grab eurotechwdt.
Message-ID: <20080812125840.GA13910@cs181140183.pp.htv.fi>
References: <489E0F5A.8010404@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <489E0F5A.8010404@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 11:42:50PM +0200, Rene Herman wrote:
> [ Andrew: not submitted ]
>
> Hi Wim.
>
> I'm going over a list of drivers that break the boot of randconfig  
> kernels by keeping resources busy:
>...

WTF?

You are expecting randconfig kernels to boot?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

