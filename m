Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbXGUXH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbXGUXH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 19:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXGUXHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 19:07:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48449 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbXGUXHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 19:07:47 -0400
Date: Sat, 21 Jul 2007 16:10:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sebastian Siewior <sebastian@breakpoint.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2o: defined but not used.
Message-Id: <20070721161010.de703d40.randy.dunlap@oracle.com>
In-Reply-To: <20070721033133.ed47aa6a.akpm@linux-foundation.org>
References: <20070720225817.607502287@ayoka.breakpoint.cc>
	<20070721033133.ed47aa6a.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 03:31:33 -0700 Andrew Morton wrote:

> On Sat, 21 Jul 2007 00:58:01 +0200 Sebastian Siewior <sebastian@breakpoint.cc> wrote:
> 
> > Got with randconfig
> 
> randconfig apparently generates impossible configs.  Please always
> run `make oldconfig' after the randconfig, then do the test build.

This one is not impossible.  Patch looks good.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
