Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbXBKAbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbXBKAbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 19:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXBKAbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 19:31:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbXBKAbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 19:31:35 -0500
Date: Sat, 10 Feb 2007 19:31:30 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070211003130.GB6849@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 03:07:10PM -0800, Andrew Morton wrote:
 > 
 > I'm getting fed up of holding onto hundreds of patches against subsystem
 > trees, sending them over and over again seeing and nothing happen.  I sent 242
 > patches out to subsystem maintainers on Monday and look at what's still here.
 > 
  > agpgart-allow-drm-populated-agp-memory-types-tidy.patch
 > remove-hotplug-cpu-crap-from-cpufreq.patch
 > rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
 > ondemand-governor-restructure-the-work-callback.patch
 > ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
 > cpu_freq_table-shouldnt-be-a-def_tristate.patch
 > 
 >   -> davej

Apologies, I suck.
I'll dispose of these appropriately tonight.

		Dave

-- 
http://www.codemonkey.org.uk
