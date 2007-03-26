Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbXCZWuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbXCZWuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933763AbXCZWuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:50:02 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35396 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933769AbXCZWuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:50:01 -0400
Date: Tue, 27 Mar 2007 00:50:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.16.44] ieee1394: dv1394: fix CardBus card ejection
Message-ID: <20070326225005.GL16477@stusta.de>
References: <tkrat.7af9edf7b7c51abd@s5r6.in-berlin.de> <tkrat.24b1704ea6395e8c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tkrat.24b1704ea6395e8c@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 09:26:05PM +0200, Stefan Richter wrote:

> Fix NULL pointer dereference on hot ejection of a FireWire card while
> dv1394 was loaded.  http://bugzilla.kernel.org/show_bug.cgi?id=7121
> I did not test card ejection with open /dev/dv1394 files yet.
>...

Thanks, applied.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

