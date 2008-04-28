Return-Path: <linux-kernel-owner+w=401wt.eu-S965542AbYD1U5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965542AbYD1U5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936210AbYD1U5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:57:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53265 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934704AbYD1U5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:57:07 -0400
Date: Mon, 28 Apr 2008 23:56:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <wtarreau@hera.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4 usage statistics
Message-ID: <20080428205631.GA2813@cs181133002.pp.htv.fi>
References: <20080428202433.GA13417@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080428202433.GA13417@hera.kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a note that some "how many" and "which version exactly" data is 
available from [1] which is generated from data users send through a 
cron job with data from nearly 5000 machines reported during the last 
60 days.

When clicking on a version (e.g. "2.4.27") you can also see which of 
them are distribution kernels.

Kinda shocking that 14% of these machines are not running kernel 2.6 ...

Considering how this data is generated it obviously shows only part of 
the picture, and your survey will hopefully bring data what we could do 
for making kernel 2.6 more attractive (not meant against your work, but 
we should aim at bringing users to 2.6).

cu
Adrian

[1] http://counter.li.org/reports/systemstats.php

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

