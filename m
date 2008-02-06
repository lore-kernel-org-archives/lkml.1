Return-Path: <linux-kernel-owner+w=401wt.eu-S1763406AbYBFBxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406AbYBFBxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbYBFBxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:53:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:56994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759699AbYBFBxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:53:34 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH for review] ACPI: Create /sys/firmware/acpi/interrupts/ counters
Date: Tue, 5 Feb 2008 20:53:06 -0500
User-Agent: KMail/1.9.5
Cc: Greg KH <gregkh@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200802050230.10873.lenb@kernel.org> <200802051812.09228.lenb@kernel.org> <200802051744.36371.bjorn.helgaas@hp.com>
In-Reply-To: <200802051744.36371.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802052053.06427.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 19:44, Bjorn Helgaas wrote:
> On Tuesday 05 February 2008 04:12:09 pm Len Brown wrote:
> > is there
> > a version of cat that prints the file name before
> > the contents of each file?
> 
> I use "grep . *" for this sort of thing.

good tip, bjorn, thanks!

/sys/devices/system/cpu/cpu0/cpufreq # grep . *
affected_cpus:0
cpuinfo_cur_freq:1596000
cpuinfo_max_freq:2660000
cpuinfo_min_freq:1596000
scaling_available_frequencies:2660000 2128000 1596000
scaling_available_governors:conservative ondemand userspace powersave performance
scaling_cur_freq:1596000
scaling_driver:centrino
scaling_governor:ondemand
scaling_max_freq:2660000
scaling_min_freq:1596000
