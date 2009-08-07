Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZHGRgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZHGRgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZHGRgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:36:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48233
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbZHGRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:36:01 -0400
Date: Fri, 07 Aug 2009 10:36:10 -0700 (PDT)
Message-Id: <20090807.103610.209136140.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the
 IRQ context
From: David Miller <davem@davemloft.net>
In-Reply-To: <200908071927.36367.bzolnier@gmail.com>
References: <200908071355.21648.bzolnier@gmail.com>
	<20090807.090158.45976865.davem@davemloft.net>
	<200908071927.36367.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Fri, 7 Aug 2009 19:27:36 +0200

> Are you trying to tell me that after 6 weeks there is still no public
> tree to hold future IDE changes?
> 
> If this is indeed a case here I hope that it will get addressed ASAP.

IDE is deep maintainence, we shouldn't be doing lots of changes,
cleanups, and things of this nature.  So urgency and timeliness
is on a sincerely different scale for it.

On the other hand, if you've been looking, I've been applying
networking patches to net-2.6 and net-next-2.6 by the truckload
on a daily basis because it is in active development.
