Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbYBNPFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbYBNPFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYBNPEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:04:52 -0500
Received: from smtp-107-backup.nerim.net ([62.4.16.107]:62226 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752392AbYBNPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:04:52 -0500
Date: Thu, 14 Feb 2008 16:04:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alasdair G Kergon <agk@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: quilt series
Message-ID: <20080214160442.02b83ffb@hyperion.delvare>
In-Reply-To: <20080215014210.73c71078.sfr@canb.auug.org.au>
References: <20080215014210.73c71078.sfr@canb.auug.org.au>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, 15 Feb 2008 01:42:10 +1100, Stephen Rothwell wrote:
> To make my life easier, can I ask that the series file for
> any quilt trees in the linux-next tree have a comment at the
> top to identify their base (either a SHA1 or some other ref
> in Linus' tree).  Like this:
> 
> # BASE <SHA1 or ref>

Done. Right now it says:

# BASE 2.6.25-rc1-git3

Is it OK with you?

-- 
Jean Delvare
