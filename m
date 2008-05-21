Return-Path: <linux-kernel-owner+w=401wt.eu-S1765469AbYEUTTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765469AbYEUTTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYEUTSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:18:55 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49057 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYEUTSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:18:54 -0400
Date: Wed, 21 May 2008 22:16:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] frv: export empty_zero_page
Message-ID: <20080521191639.GI15355@cs181133002.pp.htv.fi>
References: <20080521174203.GG15355@cs181133002.pp.htv.fi> <7195.1211396122@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7195.1211396122@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 07:55:22PM +0100, David Howells wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > EXPORT_SYMBOL_GPL(empty_zero_page);
> 
> EXPORT_SYMBOL() as elsewhere please.

ia64 also has EXPORT_SYMBOL_GPL...

> I can't test it till I get home next week.

No need to hurry.

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

