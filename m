Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYJAXnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYJAXnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYJAXnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:43:25 -0400
Received: from kroah.org ([198.145.64.141]:40890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752788AbYJAXnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:43:25 -0400
Date: Wed, 1 Oct 2008 16:26:53 -0700
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable]  Unfixed regressions in 2.6-stable
Message-ID: <20081001232653.GC31609@kroah.com>
References: <48C9A8C4.9080803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C9A8C4.9080803@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 07:24:52PM -0400, Chuck Ebbert wrote:
> Description: Thermal shutdown on x86 systems
> Version(s):  2.6.25.14 - 2.6.25.17
> Caused-by:   http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.25.14/cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch;hb=HEAD
> Version(s):  2.6.26.1 - 2.6.26.5
> Caused-by:   http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.26.1/cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch;hb=HEAD
> Patch:       http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=613e5f3376e48bd48494cf780b79b97b057d49a7
>               http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=9f497bcc695fb828da023d74ad3c966b1e58ad21
> Patch is in mainline.

Now added to the -stable queue for .25 and .26

thanks,

greg k-h
