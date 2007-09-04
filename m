Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbXIDRyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbXIDRyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 13:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbXIDRyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 13:54:35 -0400
Received: from 65.44.231.216.in-addr ([216.231.44.65]:47162 "EHLO
	hoth.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755129AbXIDRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 13:54:34 -0400
From: Zach Carter <linux@zachcarter.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1
Date: Tue, 4 Sep 2007 10:54:32 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@linux-foundation.org
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041054.32859.linux@zachcarter.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +ioc3-program-uart-predividers.patch
> +sky2-fe-chip-support.patch
> +sky2-use-debugfs-rename.patch
> +sky2-document-gphy_ctrl-bits.patch
> +sky2-dont-restrict-config-space-access.patch
> +sky2-advanced-error-reporting.patch
> +sky2-use-pci_config-access-functions.patch
> +sky2-use-net_device-internal-stats.patch
> +ktime_sub_ns-analog-of-ktime_add_ns.patch
> +export-reciprocal_value-for-modules.patch
> +sky2-hardware-receive-timestamp-counter.patch
> +sky2-avoid-divide-in-receive-path.patch
> +sky2-118.patch

Folks,

I've got these messages since installing 2.6.23-rc4-mm1:

sky2 0000:07:00.0: error interrupt status=0x80000000
printk: 4 messages suppressed.
sky2 0000:07:00.0: error interrupt status=0x80000000
printk: 4 messages suppressed.
sky2 0000:07:00.0: error interrupt status=0x80000000
printk: 4 messages suppressed.
sky2 0000:07:00.0: error interrupt status=0x80000000
printk: 4 messages suppressed.
sky2 0000:07:00.0: error interrupt status=0x80000000
printk: 5 messages suppressed.
sky2 0000:07:00.0: error interrupt status=0x80000000
printk: 5 messages suppressed.
sky2 0000:07:00.0: error interrupt status=0x80000000
printk: 4 messages suppressed.
sky2 0000:07:00.0: error interrupt status=0x80000000
printk: 4 messages suppressed.
sky2 0000:07:00.0: error interrupt status=0x80000000
printk: 4 messages suppressed.
sky2 0000:07:00.0: error interrupt status=0x80000000

The laptop is a Sony VAIO SZ430N/B

Despite the errors, the interface appears to be working well enough.

I'd be happy to supply additional information, try out patches, or 
submit a bugzilla if needed.

thanks!

-Zach
