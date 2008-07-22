Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYGVUuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYGVUuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYGVUuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:50:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbYGVUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:50:05 -0400
Date: Tue, 22 Jul 2008 13:49:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: suresh.b.siddha@intel.com, hpa@zytor.com, tglx@linutronix.de,
       arjan@linux.intel.com, andi@firstfloor.org, ebiederm@xmission.com,
       jbarnes@virtuousgeek.org, steiner@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
 x2apic support
Message-Id: <20080722134909.2cbf719b.akpm@linux-foundation.org>
In-Reply-To: <20080710195320.GA23322@elte.hu>
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710195320.GA23322@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 21:53:20 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> For review and testing purposes i've created a new topic branch for 
> this: tip/x86/x2apic and have picked up your patches into it.

This has today turned up in linux-next and I'm having to rework 2.6.27
patches to compensate for it.

Which means that I now need to wait until this work goes into mainline
before I can merge those patches or I need to undo those fixes, route
around Suresh's changes and then force you to fix the resulting damage.

What's the score here?  Is this stuff going into 2.6.27?
