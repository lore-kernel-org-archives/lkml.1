Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbZD0UHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbZD0UHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758870AbZD0UHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:07:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZD0UHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:07:03 -0400
Message-ID: <49F61040.90700@zytor.com>
Date: Mon, 27 Apr 2009 13:06:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com> <1240553210.6842.871.camel@yhuang-dev.sh.intel.com> <20090424100943.GJ27264@erda.amd.com> <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com> <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com> <49F5646F.4000305@linux.intel.com> <alpine.DEB.2.00.0904271027580.24293@gandalf.stny.rr.com> <20090427170528.GD6781@mit.edu>
In-Reply-To: <20090427170528.GD6781@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Simply preparing a patent application for filing can take a
> non-trivial amount of time.  I'd suggest that you should ask your
> patent attorney whether he is planning on filing internationally, or
> just in the US.  
> 
> If he (or she) is only planning only in the US, unlike the rest of the
> world, the US is not a first-to-file, so as long as you have proof of
> when you invented it --- for example, getting a description of your
> invention notarized --- you might be able to get clearance from your
> legal department to submit the patch while the patent application is
> getting prepared.

Keep in mind, though, the one-year disclosure-to-file statutory bar.

	-hpa
