Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbYB1RMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbYB1RMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbYB1RL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:11:58 -0500
Received: from mail.tmr.com ([64.65.253.246]:52449 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbYB1RL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:11:57 -0500
Message-ID: <47C6EBF3.8080703@tmr.com>
Date: Thu, 28 Feb 2008 12:14:27 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
References: <20080214162104.GA5347@ics.muni.cz> <47B88D18.8060907@tlinx.org>
In-Reply-To: <47B88D18.8060907@tlinx.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:

>    You didn't say anything about #processors or speed, nor
> did you say anything about your hard disk's raw-io ability.
> You also didn't mention what kernel version or whether or not
> you were using the new UID-group cpu scheduler in 2.6.24 (which likes
> to default to 'on'; not a great choice for single-user, desktop-type
> machines, if I understand its grouping policy).
> Are you sure neither end of the copy is cpu-bound on ssh/scp
> encrypt/decrypt calculations? It might not just be inability
> to read from disk, but low cpu availability.  Scp can be alot
> more CPU intensive than you would expect...  Just something to
> consider...
> 
Good point, and may I note that you *can* choose your encryption, I use 
'blowfish' for normal operation, since I have some faitly slow machines 
with a Gbit net between them.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
