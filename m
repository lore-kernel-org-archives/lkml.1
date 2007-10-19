Return-Path: <linux-kernel-owner+w=401wt.eu-S934670AbXJSFay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbXJSFay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbXJSFal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:30:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44345 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbXJSFaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:30:39 -0400
Date: Thu, 18 Oct 2007 22:30:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Make advansys depend on CONFIG_VIRT_TO_BUS
Message-Id: <20071018223023.d805c8c4.akpm@linux-foundation.org>
In-Reply-To: <20071018222017.514df7b9.randy.dunlap@oracle.com>
References: <20071019150431.996522c5.sfr@canb.auug.org.au>
	<20071018222017.514df7b9.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 22:20:17 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 19 Oct 2007 15:04:31 +1000 Stephen Rothwell wrote:
> 
> > At least for now.
> 
> Please explain "why" in the changelog (what changelog?).
> 
> E.g.:
> so that make allmodconfig on powerpc will have a better chance
> of building.

My version of this patch does that.  I'll be sending it into Linus in an
hour or so.
