Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbYBGWMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbYBGWMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbYBGWLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:11:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59007 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004AbYBGWLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:11:52 -0500
Date: Thu, 7 Feb 2008 14:11:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: jirislaby@gmail.com, stephen.neuendorffer@xilinx.com,
       grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
       paulus@samba.org, galak@gate.crashing.org, benh@kernel.crashing.org,
       torvalds@linux-foundation.org
Subject: Re: Xilinx: hwicap driver comments
Message-Id: <20080207141143.618cc173.akpm@linux-foundation.org>
In-Reply-To: <20080207153545.14a9c8ed@weaponx>
References: <47AB6552.7040503@gmail.com>
	<20080207124203.147ce300.akpm@linux-foundation.org>
	<20080207153545.14a9c8ed@weaponx>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 15:35:45 -0600
Josh Boyer <jwboyer@gmail.com> wrote:

> > Guys, can we all play too?
> 
> Sure.  You could add my tree to -mm if you want.  Though I'd really
> rather if we all sync up with Paul sooner so you don't have to track 5
> or 6 "powerpc" trees.

Yes, I was trying to pull Kumar's tree for a while.  I still am doing so,
but it's presently 6.5MB of conflicts, so I'll give up on that ;)

In theory, your 2.6.x+1 material shold be ready to go well in advance of
the 2.6.x release day (hah), so it'd be good if it could be in Paul's tree
during 2.6.x's late -rc's.
