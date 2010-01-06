Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929Ab0AFHou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0AFHou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485Ab0AFHot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:44:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:47367 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751612Ab0AFHos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:44:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18NAt1jWoUNdpyqEMdXRrR2fd9ZIuwvGYvRsHnhyB
	z5ci4y70H4uPcQ
Subject: Re: tbench regression with 2.6.33-rc1
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262760774.32058.2.camel@minggr.sh.intel.com>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1261902760.6201.33.camel@marge.simson.net>
	 <1262052582.10685.59.camel@minggr.sh.intel.com>
	 <1262064292.6412.30.camel@marge.simson.net>
	 <1262063959.13697.6.camel@minggr.sh.intel.com>
	 <1262065745.17082.0.camel@marge.simson.net>
	 <1262757688.6007.5.camel@marge.simson.net>
	 <1262757307.32058.0.camel@minggr.sh.intel.com>
	 <1262760774.32058.2.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Wed, 06 Jan 2010 08:44:45 +0100
Message-Id: <1262763885.1034.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 14:52 +0800, Lin Ming wrote:
> On Wed, 2010-01-06 at 13:55 +0800, Lin Ming wrote:
> > On Wed, 2010-01-06 at 14:01 +0800, Mike Galbraith wrote:
> > > Hi,
> > > 
> > > Have you tried tbench with the vmark regression fix?  If not, mind
> > > giving it a shot?
> 
> I just test the patch with 2.6.33-rc2, but no help.
> Still ~4% regression compared to 2.6.32.

Darn.  Thanks for testing.

	-Mike

