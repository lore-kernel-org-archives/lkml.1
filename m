Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbXD2OKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbXD2OKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 10:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbXD2OKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 10:10:00 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:46014 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbXD2OJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 10:09:59 -0400
Date: Sun, 29 Apr 2007 16:07:23 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
cc: ck@vds.kolivas.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>
Subject: Re: Best CONFIG_HZ value for scheduler testing?
In-Reply-To: <200704271044.13916.Martin@lichtvoll.de>
Message-ID: <Pine.LNX.4.61.0704291606450.22744@yvahk01.tjqt.qr>
References: <200704271044.13916.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 27 2007 10:44, Martin Steigerwald wrote:
>
>Hi Con and Ingo!
>
>What would be the best CONFIG_HZ value for scheduler testing? I used 
>1000HZ for a long time, but use 300HZ since 2.6.20. This worked well 
>enough for sd-0.46 and previous versions and ck patches...

CONFIG_HZ=1337
(SCNR.)


Jan
-- 
