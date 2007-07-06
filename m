Return-Path: <linux-kernel-owner+w=401wt.eu-S1762252AbXGFRC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762252AbXGFRC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXGFRCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:02:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbXGFRCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:02:17 -0400
Date: Fri, 6 Jul 2007 13:02:10 -0400
From: Dave Jones <davej@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Liunx power consumption on laptops -- Enormous progress in the
	last few months
Message-ID: <20070706170210.GA11214@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
References: <468D4D82.8030009@linux.intel.com> <468E6F0C.1090601@redhat.com> <468E6F4C.8000601@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468E6F4C.8000601@linux.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 09:35:24AM -0700, Arjan van de Ven wrote:

 > > Where is the ondemand-fix.patch? I can't find any link to it.
 > 
 > just click on it in the graph ;_
 > 
 > it's also http://www.linuxpowertop.org/patches/ondemand-fix.patch 
 > (which is submitted already to the maintainers)

Should be in cpufreq.git (and thus, -mm) too, waiting for .23 to open up.

	Dave

-- 
http://www.codemonkey.org.uk
