Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbZFLGih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbZFLGih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZFLGi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:38:29 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:44640 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZFLGi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:38:28 -0400
Date: Fri, 12 Jun 2009 08:37:44 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>
Subject: Re: [patch 05/38] s390: hibernation support for s390
Message-ID: <20090612083744.3d0d3fa4@skybase>
In-Reply-To: <20090608064451.GD1444@ucw.cz>
References: <20090604161847.513682672@de.ibm.com>
	<20090604161900.659762303@de.ibm.com>
	<20090608064451.GD1444@ucw.cz>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 08:44:51 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2009-06-04 18:18:52, Martin Schwidefsky wrote:
> > From: Hans-Joachim Picht <hans@linux.vnet.ibm.com>
> > 
> > This patch introduces the hibernation backend support to the 
> > s390 architecture. Now it is possible to suspend a mainframe Linux 
> > guest using the following command:
> > 
> > echo disk > /sys/power/state
> 
> Should this one be last in series?
> 
> Otherwise no obvious problems...

Ok, I will move the base patch to the end of the patch queue.
Thanks for the review.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

