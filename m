Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbZKYAWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbZKYAWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933385AbZKYAWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:22:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45706 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102AbZKYAWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:22:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] PM: Fix kernel-doc notation
Date: Wed, 25 Nov 2009 01:18:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
References: <1258877637.4495.45.camel@ht.satnam>
In-Reply-To: <1258877637.4495.45.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200911250118.47015.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 November 2009, Jaswinder Singh Rajput wrote:
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
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>

Applied to suspend-2.6/linux-next.

Thanks,
Rafael
