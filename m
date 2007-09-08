Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbXIHODl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbXIHODl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 10:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXIHODd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 10:03:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40957 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752672AbXIHODc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 10:03:32 -0400
Date: Sat, 8 Sep 2007 15:11:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
Message-ID: <20070908151150.22ebcd4c@the-village.bc.nu>
In-Reply-To: <200709080649.53876.nickpiggin@yahoo.com.au>
References: <200709071526.51169.jesse.barnes@intel.com>
	<20070908112922.3fd41adc@the-village.bc.nu>
	<200709080649.53876.nickpiggin@yahoo.com.au>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> AMD processors guarantee loads are ordered and stores are ordered
> (with exceptions of non-temporal, and non-wb policy).
> 
> As for the others that do out of order stores, are any of them SMP?

IDT winchip isn't, Geode isn't
