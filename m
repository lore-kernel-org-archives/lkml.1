Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbXDFKmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbXDFKmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXDFKmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:42:22 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44714 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbXDFKmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:42:21 -0400
X-Originating-Ip: 74.109.98.130
Date: Fri, 6 Apr 2007 06:38:25 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Dave Jones <davej@redhat.com>
cc: Adrian Bunk <bunk@stusta.de>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [2.6 patch] the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI
In-Reply-To: <20070406102914.GA27372@redhat.com>
Message-ID: <Pine.LNX.4.64.0704060637400.26474@CPE00045a9c397f-CM001225dbafb6>
References: <20070406101928.GB29169@stusta.de> <20070406102914.GA27372@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Dave Jones wrote:

> On Fri, Apr 06, 2007 at 12:19:28PM +0200, Adrian Bunk wrote:
>  > This patch contains the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI.
>  >
>  > Signed-off-by: Adrian Bunk <bunk@stusta.de>
>  > Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
> lets kill this in 2.6.22

given that there's no way this is going to make it into 2.6.21, isn't
that what adrian is proposing here?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
