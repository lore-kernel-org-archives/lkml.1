Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbYIXWg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbYIXWg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYIXWgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:36:50 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:56920 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbYIXWgu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:36:50 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: Warning/Oops report of the week of September 16th, 2008
Date: Thu, 25 Sep 2008 00:36:46 +0200
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       tglx@tglx.de, mingo@elte.hu
References: <20080916092206.6342c498@infradead.org>
In-reply-To: <20080916092206.6342c498@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809250036.47277.elendil@planet.nl>
X-OriginalArrivalTime: 24 Sep 2008 22:36:47.0800 (UTC) FILETIME=[07967B80:01C91E96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Dropped a few irrelevant lists.)

> Rank 6: parport_device_proc_register (warning)
>         Reported 62 times (3942 total reports)
>         Duplicate /proc registration in the parport driver
>         This warning was last seen in version 2.6.26.3, and first seen
>         in 2.6.24-rc5.

Note that I'm still seeing this in 2.6.27-rc7. This is now one of the 
oldest entries in the list and as it happens for *every* print job, it's 
quite an annoying one.

Unfortunately I still cannot get kerneloops to work for me.
