Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZBCQr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZBCQr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZBCQqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:46:54 -0500
Received: from ns2.suse.de ([195.135.220.15]:55969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbZBCQqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:46:52 -0500
From: Thomas Renninger <trenn@suse.de>
To: davej@codemonkey.org.uk
Cc: mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: CPUFREQ: Ondemand and powernow-k8 enhancements/fixes/cleanups
Date: Tue,  3 Feb 2009 17:46:39 +0100
Message-Id: <1233679606-1971-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the same I sent out some days ago, but messed up the
cpufreq list address.

The patches are based against Dave's cpufreq git tree's fixes branch.
There is also the one from Mark Langsdorf (adjusted to latest tree)
included which got posted on the cpufreq list recently.
guilt should add the
From: Mark Langsdorf ...
tag right, so that he shows up as the author of this one.

Dave, can you add these to your tree, please.

Thanks,

    Thomas


