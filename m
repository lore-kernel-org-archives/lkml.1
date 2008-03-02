Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYCBISR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYCBISR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 03:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYCBIR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 03:17:59 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60532 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbYCBIR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 03:17:59 -0500
Date: Sun, 2 Mar 2008 10:16:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cleanup: correct tabbing of check_kill_permission()
Message-ID: <20080302081630.GH25835@cs181133002.pp.htv.fi>
References: <47C9D986.3040805@kernel.org> <20080302004920.GA31969@infradead.org> <47CA37E7.2030404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47CA37E7.2030404@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 09:15:19PM -0800, Andrew G. Morgan wrote:
>...
> I ran it through scripts/checkpatch.pl - it said it was ok
>...

checkpatch is just a tool pointing to some common mistakes, not the 
definite authority for proving that code is stylistically correct.

Similar to the fact that I hope you wouldn't claim your code was working 
correctly only because gcc compiled it without warnings...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

