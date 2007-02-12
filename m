Return-Path: <linux-kernel-owner+w=401wt.eu-S1030448AbXBLW4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448AbXBLW4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030450AbXBLW4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:56:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46125 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030448AbXBLW4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:56:45 -0500
Date: Mon, 12 Feb 2007 14:56:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, adobriyan@openvz.org
Subject: Re: - rdmsr_on_cpu-wrmsr_on_cpu.patch removed from -mm tree
Message-Id: <20070212145631.dee78596.akpm@linux-foundation.org>
In-Reply-To: <200702122324.44611.andi@firstfloor.org>
References: <200702082132.l18LWhl4027000@shell0.pdx.osdl.net>
	<200702111138.23253.ak@suse.de>
	<20070212140043.6586665c.akpm@linux-foundation.org>
	<200702122324.44611.andi@firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Feb 2007 23:24:44 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > I backed out x86_64-mm-msr-on-cpu.patch (again) and went with Alexey's
> > second version (again).  It works fine.
> 
> I think I'll just drop the thing. Nuisance:gain seems to be out of order

It hasn't caused me any problems.  The nuisance factor at your end
is all due to trying to get the old patch to work rather than using the new one.
