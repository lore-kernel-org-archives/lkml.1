Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbYBMWng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbYBMWng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYBMWn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:43:26 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50855 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbYBMWnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:43:24 -0500
Date: Thu, 14 Feb 2008 00:43:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Emelyanov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported
	symbols going away
Message-ID: <20080213224308.GD12383@cs181133002.pp.htv.fi>
References: <1202941327.18204.11.camel@brick> <20080213223455.GB12383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080213223455.GB12383@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW:

Sorry and it's not your fault if my answer was a bit harsh.

Your patch forces a nonsense that until now only Andrew tried to enforce 
(which BTW made me avoiding him whenever possible and never looking at 
-mm anymore).

There's simply no point in treating the removal of exports differently
from the many other API breaks we have in each release.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

