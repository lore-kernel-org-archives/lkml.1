Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662Ab0ALD31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0ALD31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271Ab0ALD30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:29:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:52781 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab0ALD30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:29:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,259,1262592000"; 
   d="scan'208";a="483227035"
Subject: Re: tbench regression with 2.6.33-rc1
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1263263621.5905.6.camel@marge.simson.net>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1263211680.4244.50.camel@laptop>
	 <1263226612.6290.9.camel@marge.simson.net>
	 <1263258546.3598.19.camel@minggr.sh.intel.com>
	 <1263263621.5905.6.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 12 Jan 2010 11:13:36 +0800
Message-Id: <1263266016.3598.24.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 10:33 +0800, Mike Galbraith wrote:
> On Tue, 2010-01-12 at 09:09 +0800, Lin Ming wrote:
> > On Tue, 2010-01-12 at 00:16 +0800, Mike Galbraith wrote:
> 
> > > I've been all through it too, same result.  The below may make a bit of
> > > difference, but really has diddly spit to do with this oddity.
> > 
> > I test this patch applied to 2.6.33-rc3, but no help on tbench
> > regression.
> 
> Did you try it with the vmark fix also applied?  I would have expected
> at least a _little_ improvement.  (but then this regression _is_ a bit
> odd anyway)

I re-tested with both patches applied, but still no help.

BTW, why do you call that patch "vmark" fix? :)
I just wonder what "vmark" means.

Lin Ming

