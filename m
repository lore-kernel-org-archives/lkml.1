Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447Ab0AFHIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0AFHIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369Ab0AFHIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:08:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:7804 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab0AFHIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:08:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,225,1262592000"; 
   d="scan'208";a="528855138"
Subject: Re: tbench regression with 2.6.33-rc1
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262757307.32058.0.camel@minggr.sh.intel.com>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1261902760.6201.33.camel@marge.simson.net>
	 <1262052582.10685.59.camel@minggr.sh.intel.com>
	 <1262064292.6412.30.camel@marge.simson.net>
	 <1262063959.13697.6.camel@minggr.sh.intel.com>
	 <1262065745.17082.0.camel@marge.simson.net>
	 <1262757688.6007.5.camel@marge.simson.net>
	 <1262757307.32058.0.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Wed, 06 Jan 2010 14:52:54 +0800
Message-Id: <1262760774.32058.2.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 13:55 +0800, Lin Ming wrote:
> On Wed, 2010-01-06 at 14:01 +0800, Mike Galbraith wrote:
> > Hi,
> > 
> > Have you tried tbench with the vmark regression fix?  If not, mind
> > giving it a shot?

I just test the patch with 2.6.33-rc2, but no help.
Still ~4% regression compared to 2.6.32.

Lin Ming

> 
> OK. I'll test soon.
> 
> > 
> > 	-Mike
> > 

