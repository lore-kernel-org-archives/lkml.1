Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZKVRw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZKVRw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 12:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbZKVRw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 12:52:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43661 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbZKVRw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 12:52:56 -0500
Date: Sun, 22 Nov 2009 18:52:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: Fix kernel-doc notation
Message-ID: <20091122175256.GA28466@elf.ucw.cz>
References: <1258877637.4495.45.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258877637.4495.45.camel@ht.satnam>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-11-22 13:43:57, Jaswinder Singh Rajput wrote:
> 
> Fix the following htmldocs warnings:
> 
>   Warning(drivers/base/power/main.c:249): No description found for parameter 'master'
>   Warning(drivers/base/power/main.c:249): Excess function parameter 'slave' description in 'device_pm_wait_for_slaves'
>   Warning(drivers/base/power/main.c:292): No description found for parameter 'master'
>   Warning(drivers/base/power/main.c:292): Excess function parameter 'slave' description in 'device_pm_check_slaves'
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
