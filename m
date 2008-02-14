Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbYBNI0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbYBNI0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 03:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYBNI0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 03:26:07 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52613 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYBNI0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 03:26:06 -0500
Date: Thu, 14 Feb 2008 10:25:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Driver removals
Message-ID: <20080214082547.GJ12383@cs181133002.pp.htv.fi>
References: <fp08q7$jv0$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fp08q7$jv0$1@ger.gmane.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 09:26:26PM -0500, Bill Davidsen wrote:
>...
> In general, if a driver works and is being used, until it *needs*  
> attention I see no reason to replace it. I don't agree that "it forces  
> people to try the new driver" is a valid reason, being unmaintained is  
> only a problem if it needs maintenance. I am not going to reopen that  
> topic, I'm simply noting a general opposition to unfunded mandates, and  
> requiring changes to kernel, module and/or rc.local config is just that.

Keeping a working unmaintained driver in the tree is not a big deal - we 
have hundreds of them.

But you miss the main point that removal of an obsolete driver with a 
new replacement driver forces people to finally report their problems 
with the new driver, thus making the new driver better.

After all, the people who scream loudly that the new driver doesn't work 
for them when the old driver gets removed are the people who should have 
reported their problems with the new driver many years ago...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

