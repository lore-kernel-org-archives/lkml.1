Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698Ab0AVLpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0AVLpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 06:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996Ab0AVLpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 06:45:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58108 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753701Ab0AVLpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 06:45:01 -0500
Date: Fri, 22 Jan 2010 11:46:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/24] drivers/block/floppy.c cleanups
Message-ID: <20100122114653.4afd606d@lxorguk.ukuu.org.uk>
In-Reply-To: <87fx5yh0va.fsf@basil.nowhere.org>
References: <cover.1264133863.git.joe@perches.com>
	<87fx5yh0va.fsf@basil.nowhere.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Philosophically I'm not sure it's that great an idea to make bad code
> look better without actually fixing/rewriting it. It's like putting
> lipstick on a pig.

Unpacking the mess and sorting out the whacky macros is more like
removing all muck from the mechanism so you can see what needs to be done.

So I disagree - its a useful first step only
