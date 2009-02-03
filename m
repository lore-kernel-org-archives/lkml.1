Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZBCR3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZBCR3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbZBCR3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:29:32 -0500
Received: from testure.choralone.org ([194.9.77.134]:41898 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbZBCR3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:29:31 -0500
X-Greylist: delayed 2466 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 12:29:31 EST
Date: Tue, 3 Feb 2009 11:48:20 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Thomas Renninger <trenn@suse.de>
Cc: mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: CPUFREQ: Ondemand and powernow-k8 enhancements/fixes/cleanups
Message-ID: <20090203164820.GB10486@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Thomas Renninger <trenn@suse.de>, mark.langsdorf@amd.com,
	cpufreq@vger.kernel.org, venkatesh.pallipadi@intel.com,
	linux-kernel@vger.kernel.org
References: <1233679606-1971-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233679606-1971-1-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 05:46:39PM +0100, Thomas Renninger wrote:
 > These are the same I sent out some days ago, but messed up the
 > cpufreq list address.
 > 
 > The patches are based against Dave's cpufreq git tree's fixes branch.
 > There is also the one from Mark Langsdorf (adjusted to latest tree)
 > included which got posted on the cpufreq list recently.
 > guilt should add the
 > From: Mark Langsdorf ...
 > tag right, so that he shows up as the author of this one.
 > 
 > Dave, can you add these to your tree, please.

Thanks Thomas,
 I'll get to these today and queue them up.

	Dave

-- 
http://www.codemonkey.org.uk
