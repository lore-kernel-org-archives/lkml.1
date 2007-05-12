Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbXELBkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbXELBkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 21:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbXELBks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 21:40:48 -0400
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:36312 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751821AbXELBkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 21:40:47 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.1
Date: Sat, 12 May 2007 02:40:52 +0100
From: Jose Celestino <japc@co.sapo.pt>
To: Matt Mackall <mpm@selenic.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Re: [announce] Intel announces the PowerTOP utility for Linux
Message-ID: <20070512014052.GA4082@co.sapo.pt>
Mail-Followup-To: Matt Mackall <mpm@selenic.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org
References: <4644F726.1050806@linux.intel.com> <20070512001718.GY11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512001718.GY11166@waste.org>
X-URL: http://xpto.org/~japc
X-System: Linux morgoth.sl.pt 2.6.21-1.3116.fc7
X-UP: 02:03:28 up 28 min,  1 user,  load average: 0.28, 0.19, 0.27
X-By: japc@morgoth.sl.pt
X-GPG-key-ID: 0x07B1363B
X-GPG-key-Fingerprint: D3F3 B47B F20C 3B1E 488C B949 1B8B 8141 07B1 363B
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Words by Matt Mackall [Fri, May 11, 2007 at 07:17:19PM -0500]:
> On Fri, May 11, 2007 at 04:07:18PM -0700, Arjan van de Ven wrote:
> > 
> > What's eating the battery life of my laptop? Why isn't it many more 
> > hours? Which software component causes the most power to be burned? 
> > These are important questions without a good answer... until now.
> 
> I get:
> 
> No detailed statistics available; please enable the CONFIG_TIMER_STATS
> kernel option
> 

Must run as root (rw to /proc/timer_stats is needed).

-- 
Jose Celestino
----------------------------------------------------------------
http://www.msversus.org/     ; http://techp.org/petition/show/1
http://www.vinc17.org/noswpat.en.html
----------------------------------------------------------------
"And on the trillionth day, Man created Gods." -- Thomas D. Pate
