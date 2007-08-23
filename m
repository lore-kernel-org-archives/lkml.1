Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbXHWAGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbXHWAGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXHWAFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:05:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932907AbXHWAFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:05:51 -0400
Date: Wed, 22 Aug 2007 20:05:41 -0400
From: Dave Jones <davej@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS
Message-ID: <20070823000541.GB18739@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
References: <1187420935.4200.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187420935.4200.16.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 12:08:54AM -0700, Joe Perches wrote:


 >  AGPGART DRIVER
 >  P:	David Airlie
 >  M:	airlied@linux.ie
 >  T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 >  S:	Maintained
 > +F:	drivers/char/agp/

+F: include/linux/agp*


 >  CPU FREQUENCY DRIVERS
 >  P:	Dave Jones
 >  M:	davej@codemonkey.org.uk
 >  L:	cpufreq@lists.linux.org.uk
 >  W:	http://www.codemonkey.org.uk/projects/cpufreq/
 >  T:	git kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 >  S:	Maintained
 > +F:	arch/i386/kernel/cpu/cpufreq/
 > +F:	drivers/cpufreq/
 > +F:	include/linux/cpufreq.h

ACK, looks fine.

+F: arch/x86_64/kernel/cpu/cpufreq/ too, but that's just a symlink
right now, and the x86 unification that Thomas & Ingo are working
on solves that problem anyway, so no biggie.

	Dave

-- 
http://www.codemonkey.org.uk
