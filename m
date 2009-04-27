Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbZD0Pdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbZD0Pdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZD0PdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:33:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34426 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756664AbZD0PdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:33:21 -0400
Date: Mon, 27 Apr 2009 16:33:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Huang Ying <ying.huang@intel.com>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Patenting kernel patches was Re: Re-implement MCE log ring
 buffer as per-CPU ring buffer
Message-ID: <20090427163353.3fe1f59e@lxorguk.ukuu.org.uk>
In-Reply-To: <49F5C305.60807@linux.intel.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>
	<20090422092259.GC18226@elte.hu>
	<20090422101600.GL3226@erda.amd.com>
	<1240553210.6842.871.camel@yhuang-dev.sh.intel.com>
	<20090424100943.GJ27264@erda.amd.com>
	<alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com>
	<1240818596.6842.1001.camel@yhuang-dev.sh.intel.com>
	<alpine.DEB.2.00.0904271026140.24293@gandalf.stny.rr.com>
	<49F5C305.60807@linux.intel.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And also holding up perfectly good uncontaminated patches for something
> patented seems especially wrong.
> 
> I think we should move forward with a standard non patented ring
> buffer Ying was working on for this and avoid the patent mess as
> far as possible.

Agreed. If the future patches to be presented are useful and the
licensing usable etc then they can still be merged in the future (or far
future depending how much look folks have speeding up lawyers ;))

Alan
