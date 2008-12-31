Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbYLaK6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbYLaK6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYLaK6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:58:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:51348 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYLaK6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:58:23 -0500
Date: Wed, 31 Dec 2008 12:00:13 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Jayson King <dev@jaysonking.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, shaggy@linux.vnet.ibm.com, rjw@sisk.pl,
       fabio.comolli@gmail.com
Subject: Re: Disregard: was Re: large intermittent latency spike 2.6.28 (and
 2.6.27.10), bisect commit ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325 ->
 Revert "sched_clock: prevent scd->clock from moving backwards"
Message-ID: <20081231120013.7aaf1bc3@infradead.org>
In-Reply-To: <495B40C1.4080305@jaysonking.com>
References: <495A96FF.1000200@jaysonking.com>
	<495B40C1.4080305@jaysonking.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008 03:52:01 -0600
Jayson King <dev@jaysonking.com> wrote:

> Please disregard this. I just had a latency spike again, so this is
> not the change I'm looking for... I'll need to look for what is
> causing it again, apparently not only the make -j 3 I thought, and do
> another test.


can you run latencytop to see if it can pinpoint a cause of latency?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
