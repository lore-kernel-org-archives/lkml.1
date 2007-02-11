Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXBKKmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXBKKmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 05:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXBKKmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 05:42:15 -0500
Received: from mx1.suse.de ([195.135.220.2]:42420 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbXBKKmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 05:42:10 -0500
From: Andi Kleen <ak@suse.de>
To: Dave Jones <davej@redhat.com>
Subject: Re: - rdmsr_on_cpu-wrmsr_on_cpu.patch removed from -mm tree
Date: Sun, 11 Feb 2007 11:38:23 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, adobriyan@openvz.org
References: <200702082132.l18LWhl4027000@shell0.pdx.osdl.net> <20070211001143.GB13178@redhat.com>
In-Reply-To: <20070211001143.GB13178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702111138.23253.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 February 2007 01:11, Dave Jones wrote:
> On Thu, Feb 08, 2007 at 01:32:43PM -0800, akpm@linux-foundation.org wrote:
>  > 
>  > The patch titled
>  >      rdmsr_on_cpu, wrmsr_on_cpu
>  > has been removed from the -mm tree.  Its filename was
>  >      rdmsr_on_cpu-wrmsr_on_cpu.patch
>  > 
>  > This patch was dropped because I've lost the plot on this thing
> 
> Alexey, send me the latest fixed up version of this, and I'll
> queue this up to save Andrew trying to sort it out.

I fixed it up to at least support x86-64 too

-Andi
