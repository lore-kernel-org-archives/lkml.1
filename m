Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbYIUUtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbYIUUtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYIUUn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:43:27 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:46245 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbYIUUnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:43:25 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11555] rmmod ide-cd_mod: tried to init an initialized =?utf-8?q?=C2=A0object?=, something is seriously wrong.
Date: Sun, 21 Sep 2008 22:43:20 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Jens Axboe" <jens.axboe@oracle.com>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik> <7lIhZC4hCxE.A.0gG.R0q1IB@albercik>
In-Reply-To: <7lIhZC4hCxE.A.0gG.R0q1IB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809212243.21256.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).

It was present in 2.6.27-rc6. A day or two later I checked mainline and
it was gone. I will recheck this and notify if needed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11555
> Subject		: rmmod ide-cd_mod: tried to init an initialized =C2=A0object, something is s= eriously wrong.
> Submitter	: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Date		: 2008-07-16 2:22 (68 days old)
> References	: http://marc.info/?l=linux-ide&m=122061839713526&w=4
> Handled-By	: Jens Axboe <jens.axboe@oracle.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122095622602315&w=4

Thanks,

	Mariusz
