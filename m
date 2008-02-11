Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbYBKSck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbYBKSck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYBKScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:32:21 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10510 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYBKScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:32:20 -0500
Date: Mon, 11 Feb 2008 10:30:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: ananth@in.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       sam@ravnborg.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 0/8] Create and populate toplevel tests/ for kernel
 tests
Message-Id: <20080211103011.e5e6ed23.randy.dunlap@oracle.com>
In-Reply-To: <20080211102649.2ab423ec.randy.dunlap@oracle.com>
References: <20080211104452.GB7944@in.ibm.com>
	<20080211102649.2ab423ec.randy.dunlap@oracle.com>
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

On Mon, 11 Feb 2008 10:26:49 -0800 Randy Dunlap wrote:

> On Mon, 11 Feb 2008 16:14:52 +0530 Ananth N Mavinakayanahalli wrote:
> 
> > The following series of patches create and populate the toplevel tests/
> > directory. This will henceforth be the place where all in-kernel tests
> > live.
> > 
> > All patches against 2.6.25-rc1 and are just code movement without any
> > change in functionality.
> 
> Hi,
> 
> As Linus wrote on a recent sh pull request:
> 
> "Please use "git diff -M --stat --summary" to generate the diffstat: the -M 
> enables rename detection, and the summary enables a summary of new/deleted 
> or renamed files."

Argh, you probably didn't use git, so please ignore my comment.

---
~Randy
