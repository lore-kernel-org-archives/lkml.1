Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZBCVVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZBCVVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZBCVVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:21:11 -0500
Received: from testure.choralone.org ([194.9.77.134]:42541 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZBCVVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:21:11 -0500
Date: Tue, 3 Feb 2009 16:21:06 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Thomas Renninger <trenn@suse.de>
Cc: mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: CPUFREQ: Ondemand and powernow-k8 enhancements/fixes/cleanups
Message-ID: <20090203212106.GK10486@codemonkey.org.uk>
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

'fixes' is for stuff pending for .29, which this patchset seems out
of scope for.  Unfortunatly, there's a ton of checkpatch cleanups up
the 'next' branch which makes this impossible to apply.

Can you rediff against that branch please?
 
thanks,

	Dave

-- 
http://www.codemonkey.org.uk
