Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbYBNQnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbYBNQnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbYBNQni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:43:38 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:33014 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbYBNQnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:43:37 -0500
Date: Thu, 14 Feb 2008 08:42:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alasdair G Kergon <agk@redhat.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: quilt series
Message-Id: <20080214084233.82728ab6.randy.dunlap@oracle.com>
In-Reply-To: <20080215014210.73c71078.sfr@canb.auug.org.au>
References: <20080215014210.73c71078.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 01:42:10 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> To make my life easier, can I ask that the series file for any quilt trees in the linux-next tree have a comment at the top to identify their base (either a SHA1 or some other ref in Linus' tree).  Like this:
> 
> # BASE <SHA1 or ref>
> 
> Also, if you only want a subset of the series file included, you can mark the patches with
> 
> # NEXT_PATCHES_START
> 	.
> 	.
> # NEXT_PATCHES_END

Do you allow multiple START/END blocks?

---
~Randy
