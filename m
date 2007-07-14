Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbXGNAqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbXGNAqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763668AbXGNApv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:45:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53337 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763603AbXGNAps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:45:48 -0400
Subject: Re: v2.6.22.1-rt3
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1184325752.12353.312.camel@chaos>
References: <1184325752.12353.312.camel@chaos>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 17:33:37 -0700
Message-Id: <1184373217.19670.3.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 13:22 +0200, Thomas Gleixner wrote:
> we are pleased to announce the v2.6.22.1-rt3 kernel
[...]
> This release is bugfix release:
> 
> - update of the x8664 -hrt queue (resolve boot problems)
> - gtod vsyscall fix from Gregory Haskins

I can confirm that this patch fixes booting on an 8-CPU x86-64 box that
-rt2 would not boot on.

- Josh Triplett


