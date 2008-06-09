Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbYFIHzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbYFIHzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 03:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYFIHyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 03:54:53 -0400
Received: from mail.atmel.fr ([81.80.104.162]:32947 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYFIHyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 03:54:52 -0400
Message-ID: <484CE1BA.108@atmel.com>
Date: Mon, 09 Jun 2008 09:54:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Gururaja Hebbar K R <gururajakr@sanyo.co.in>
CC: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: mmc_test : some results
References: <48495843.1050902@atmel.com> <5BF78BCE8D9BF14A83F836BD9E3916BA0DDFC3@blrms.slti.sanyo.co.in>
In-Reply-To: <5BF78BCE8D9BF14A83F836BD9E3916BA0DDFC3@blrms.slti.sanyo.co.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gururaja Hebbar K R :
> Hi Nicolas,
> 
> Could you please be kind enough to share the test program so that we can
> test mmc driver on other platforms.

mmc_test is included in the mainline kernel :
http://lkml.org/lkml/2008/5/17/45

I just selected the tests I wanted to use in the source code (in 
mmc_test_cases tab).

Cheers,
-- 
Nicolas Ferre

