Return-Path: <linux-kernel-owner+w=401wt.eu-S2992631AbXCWXJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992631AbXCWXJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992628AbXCWXJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:09:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33063 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992617AbXCWXJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:09:01 -0400
Date: Sat, 24 Mar 2007 00:09:04 +0100
From: Adrian Bunk <bunk@stusta.de>
To: roland <devzero@web.de>
Cc: Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] - Schedule mcdx for removal ? was:  warning: #warning You have not edited mcdx.h
Message-ID: <20070323230904.GY752@stusta.de>
References: <052c01c76c62$78f7f7a0$eeeea8c0@aldipc> <200703221035.19832.oneukum@suse.de> <06e401c76d9e$f0920430$eeeea8c0@aldipc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <06e401c76d9e$f0920430$eeeea8c0@aldipc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 11:59:40PM +0100, roland wrote:
> why not?
> 
> why should unused code be maintained to death ?

This driver hasn't been actively maintained for years - it's nearly 
zero-cost to carry such a driver in the kernel sources.

> if there are discussions about removing features people are still using, i 
> think it should be legitimate to discuss about removing drivers nobody 
> needs anymore....

There's a difference between obsolete features and drivers for old 
hardware: There's usually a replacement for the obsolete features.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

