Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbXFOXn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbXFOXn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbXFOXnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:43:50 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46180 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbXFOXnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:43:49 -0400
Date: Fri, 15 Jun 2007 16:44:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: mm: Fix memory/cpu hotplug section mismatch and oops.
Message-Id: <20070615164411.ec1bdcc7.randy.dunlap@oracle.com>
In-Reply-To: <20070615030241.GA28493@linux-sh.org>
References: <20070614061316.GA22543@linux-sh.org>
	<20070614183015.9DD7.Y-GOTO@jp.fujitsu.com>
	<20070615030241.GA28493@linux-sh.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 12:02:41 +0900 Paul Mundt wrote:

> On Thu, Jun 14, 2007 at 06:32:32PM +0900, Yasunori Goto wrote:
> > Thanks. I tested compile with cpu/memory hotplug off/on.
> > It was OK.
> > 
> > Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> > 
> It would be nice to have this for 2.6.22..

Yes, please.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
