Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbXCHPs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbXCHPs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbXCHPs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:48:26 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:42871 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbXCHPsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:48:24 -0500
Date: Thu, 8 Mar 2007 17:48:22 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc1: more ACPI errors (EC__)
In-Reply-To: <45EAA003.7020504@linux.intel.com>
Message-ID: <Pine.SOC.4.64.0703081743160.17040@math>
References: <Pine.SOC.4.64.0702260842260.9705@math> <45EAA003.7020504@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> please take a look at 8066 bug and patches there.

Tried patch from #9 there (with 21-rc3) and it seems to cure the problem 
for me (with IBM X20). Thanks!

-- 
Meelis Roos (mroos@linux.ee)
