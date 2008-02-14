Return-Path: <linux-kernel-owner+w=401wt.eu-S933665AbYBNPJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbYBNPJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbYBNPJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:09:14 -0500
Received: from twin.jikos.cz ([213.151.79.26]:39828 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbYBNPJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:09:12 -0500
Date: Thu, 14 Feb 2008 16:08:06 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Jean Delvare <khali@linux-fr.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: quilt series
In-Reply-To: <20080214160442.02b83ffb@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0802141606550.7699@twin.jikos.cz>
References: <20080215014210.73c71078.sfr@canb.auug.org.au>
 <20080214160442.02b83ffb@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Jean Delvare wrote:

> > To make my life easier, can I ask that the series file for any quilt 
> > trees in the linux-next tree have a comment at the top to identify 
> > their base (either a SHA1 or some other ref in Linus' tree).  Like 
> > this:
> > # BASE <SHA1 or ref>
> Done. Right now it says:
> # BASE 2.6.25-rc1-git3
> Is it OK with you?

The daily snapshots are not tagged in Linus' tree, right? So I don't think 
this would suffice.

-- 
Jiri Kosina
