Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbXJQVeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbXJQVeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXJQVd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:33:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbXJQVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:33:56 -0400
Date: Wed, 17 Oct 2007 17:33:37 -0400
From: Dave Jones <davej@redhat.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
Subject: Re: [PATCH][try 4] architectural pstate driver for powernow-k8
Message-ID: <20071017213337.GE9748@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mark Langsdorf <mark.langsdorf@amd.com>,
	linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
References: <200710091446.38432.mark.langsdorf@amd.com> <20071015154031.GA30754@redhat.com> <200710151123.45582.mark.langsdorf@amd.com> <200710151603.48489.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710151603.48489.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 04:03:48PM -0500, Mark Langsdorf wrote:
 > This patch should apply cleanly to the 2.6.23-git7 kernel.  It changes the
 > powernow-k8 driver code that deals with 3rd generation Opteron, Phenom,
 > and later processors to match the architectural pstate driver described
 > in the AMD64 Architecture Programmer's Manual Volume 2 Chapter 18.  The
 > initial implementation of the hardware pstate driver for PowerNow!
 > used some processor-version specific features, and would not be
 > maintainable in the long term as the processor features changed.
 > This architectural driver should work on all future AMD processors.
 >  
 > Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
 > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

MIME damaged, can't apply.

	Dave

-- 
http://www.codemonkey.org.uk
