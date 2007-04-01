Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXDAIny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXDAIny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 04:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbXDAIny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 04:43:54 -0400
Received: from www.osadl.org ([213.239.205.134]:40704 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932244AbXDAInx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 04:43:53 -0400
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
	tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: akpm@linux-foundation.org
Cc: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
Content-Type: text/plain
Date: Sun, 01 Apr 2007 10:43:55 +0200
Message-Id: <1175417035.28263.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-31 at 22:23 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      clocksource: driver initialize list value
> has been added to the -mm tree.  Its filename is
>      clocksource-driver-initialize-list-value.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: clocksource: driver initialize list value
> From: Daniel Walker <dwalker@mvista.com>
> 
> Update drivers/clocksource/ with list initialization.

As others pointed out already, can we please have some usefull
description why this change is necessary ? i.e. that it is a preparatory
patch to simplify the clocksource registration logic.

	tglx


