Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbYI2VUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbYI2VUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYI2VUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:20:38 -0400
Received: from eazy.amigager.de ([213.239.192.238]:52442 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYI2VUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:20:36 -0400
Date: Mon, 29 Sep 2008 23:21:42 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11654] Devices enabled in /proc/acpi/wakeup do not wake
	up any more
Message-ID: <20080929212142.GC3185@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik> <V8eU91268VO.A.wOG.L7m3IB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <V8eU91268VO.A.wOG.L7m3IB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 17:56:50 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11654
> Subject		: Devices enabled in /proc/acpi/wakeup do not wake up any more
> Submitter	: Tino Keitel <tino.keitel@gmx.de>
> Date		: 2008-09-22 20:29 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=122211535021493&w=4
> 		  http://marc.info/?l=linux-kernel&m=122224359222164&w=4
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> Patch		: http://marc.info/?l=linux-kernel&m=122238185304167&w=4
> 		  http://marc.info/?l=linux-kernel&m=122237497811138&w=4
> 

The above patches fix the problems for me.

Thanks and regards,
Tino
