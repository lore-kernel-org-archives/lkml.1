Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbXCFMkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbXCFMkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbXCFMkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:40:36 -0500
Received: from ozlabs.org ([203.10.76.45]:55340 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbXCFMkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:40:35 -0500
Subject: [PATCH 0/8] x86 boot, pda and gdt cleanups
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 23:39:07 +1100
Message-Id: <1173184747.4644.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	The GDT stuff on x86 is a little more complex than it need be, but
playing with boot code is always dangerous.  These compile and boot on
UP and SMP for me, but Andrew should let the cook in -mm for a while.

Thanks!
Rusty.

