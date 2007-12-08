Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbXLHWDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbXLHWDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 17:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXLHWDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 17:03:47 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56308 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752371AbXLHWDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:03:47 -0500
Date: Sat, 8 Dec 2007 23:03:45 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071208220345.GE20441@stusta.de>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <47584E35.7030409@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47584E35.7030409@tmr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 02:32:05PM -0500, Bill Davidsen wrote:
>...
> Sounds like a local DoS attack point to me...

As long as /dev/random is readable for all users there's no reason to 
use /dev/urandom for a local DoS...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

