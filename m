Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZJASeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZJASeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZJASd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:33:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60825
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756168AbZJASd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:33:59 -0400
Date: Thu, 01 Oct 2009 11:34:18 -0700 (PDT)
Message-Id: <20091001.113418.139794332.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: elendil@planet.nl, manty@manty.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910012021.24260.bzolnier@gmail.com>
References: <200910011125.40081.bzolnier@gmail.com>
	<20091001.094034.161463891.davem@davemloft.net>
	<200910012021.24260.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 1 Oct 2009 20:21:24 +0200

> - for the last three months you haven't debugged/fixed a single IDE issue
>   and you keep dodging every single bug-report 

I mostly do the same with networking, and I'm the maintainer there
too. :-)

And regardless of my workload, all reasonable patches and bug fixes
submitted for IDE flowed freely during this time, or were given
a review NACK.

I depend upon subsystem contributors to fix the bugs, that's how this
works.  I merely mediate, review patches, apply patches, and chip in
with some work of my own from time to time as the situation and my
workload dictate.

Nobody is forcing you to fix bugs or work on anything, you can freely
ignore every IDE related email.  Create a filter for it if you like.
:-)
