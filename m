Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbXEXUzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbXEXUzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbXEXUzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:55:31 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbXEXUza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:55:30 -0400
Date: Thu, 24 May 2007 13:55:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in
 /proc/cpuinfo
Message-Id: <20070524135513.b6efacbf.akpm@linux-foundation.org>
In-Reply-To: <20070523224637.GB15887@linux-os.sc.intel.com>
References: <20070523224637.GB15887@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 15:46:37 -0700
Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
> will be enabled automatically by current acpi-cpufreq driver and cpufreq.

So you're saying that the cpufreq code in Linus's tree aleady supports IDA?
If so, this is a 2.6.22 patch, isn't it?
