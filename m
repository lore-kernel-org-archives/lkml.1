Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbXJYRgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbXJYRgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXJYRgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:36:16 -0400
Received: from xenotime.net ([66.160.160.81]:47208 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751247AbXJYRgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:36:15 -0400
Date: Thu, 25 Oct 2007 10:36:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Johannes Berg <johannes@sipsolutions.net>, sam@ravnborg.org
Subject: Re: [PATCH 0/6] kernel-doc: add DOC: sections support
Message-Id: <20071025103611.f2ae216f.rdunlap@xenotime.net>
In-Reply-To: <20071025172932.GN17536@waste.org>
References: <11932637282902@xenotime.net>
	<20071025172932.GN17536@waste.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 12:29:32 -0500 Matt Mackall wrote:

> On Wed, Oct 24, 2007 at 03:08:48PM -0700, Randy Dunlap wrote:
> > 
> > This patch series from Johannes Berg adds support for DOC: sections
> > that are embedded in source files.
> 
> What do these look like?

There are currently 2 files in the kernel tree that contain DOC:
sections.  These are not used in the docbooks, but you can see what
they look like here:

./drivers/net/3c501.c: * DOC: 3c501 Card Notes
./drivers/net/3c501.c: * DOC: Problems
./drivers/net/3c527.c: * DOC: Traps for the unwary
./drivers/net/3c527.c: * DOC: Theory Of Operation
./drivers/net/3c527.c: * DOC: Notes

Also, Johannes has patches to use DOC: in mac80211 files.


> Kerneldoc's documentation is sadly lacking..

point taken.

---
~Randy
