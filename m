Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbXFAOYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbXFAOYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbXFAOX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:23:58 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:35529 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683AbXFAOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:23:57 -0400
Message-ID: <46602BFB.9040706@s5r6.in-berlin.de>
Date: Fri, 01 Jun 2007 16:23:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       linux1394-devel@lists.sourceforge.net,
       =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [3/3] 2.6.22-rc3: known regressions v2  (suspend, fw-ohci)
References: <465FED20.3090206@googlemail.com> <46600F34.8010404@googlemail.com>
In-Reply-To: <46600F34.8010404@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Suspend
> 
> Subject    : 2.6.22-rc1 suspend to RAM problem
> References : http://permalink.gmane.org/gmane.linux.power-management.general/5819
> Submitter  : Marcus Better <marcus@better.se>
> Handled-By : Stefan Richter <stefanr@s5r6.in-berlin.de>
>              Kristian Høgsberg <krh@bitplanet.net>
> Status     : caused by fw-ohci module

A patch is now available and was tested by Marcus yesterday:
http://marc.info/?l=linux1394-devel&m=118060953728808

The patch is part of today's linux1394-2.6.git pull request.
-- 
Stefan Richter
-=====-=-=== -==- ----=
http://arcgraph.de/sr/
