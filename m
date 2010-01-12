Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778Ab0ALEO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0ALEO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 23:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999Ab0ALEO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 23:14:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:42731 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752085Ab0ALEO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 23:14:56 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+R7hdKtX6RZqb4gIzeUOGrVSH5C+x6oGOB3BaDOf
	M7hmS9wov79Ugi
Subject: Re: tbench regression with 2.6.33-rc1
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1263266016.3598.24.camel@minggr.sh.intel.com>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1263211680.4244.50.camel@laptop>
	 <1263226612.6290.9.camel@marge.simson.net>
	 <1263258546.3598.19.camel@minggr.sh.intel.com>
	 <1263263621.5905.6.camel@marge.simson.net>
	 <1263266016.3598.24.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Tue, 12 Jan 2010 05:14:52 +0100
Message-Id: <1263269692.5948.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 11:13 +0800, Lin Ming wrote:
> On Tue, 2010-01-12 at 10:33 +0800, Mike Galbraith wrote:
> > On Tue, 2010-01-12 at 09:09 +0800, Lin Ming wrote:
> > > On Tue, 2010-01-12 at 00:16 +0800, Mike Galbraith wrote:
> > 
> > > > I've been all through it too, same result.  The below may make a bit of
> > > > difference, but really has diddly spit to do with this oddity.
> > > 
> > > I test this patch applied to 2.6.33-rc3, but no help on tbench
> > > regression.
> > 
> > Did you try it with the vmark fix also applied?  I would have expected
> > at least a _little_ improvement.  (but then this regression _is_ a bit
> > odd anyway)
> 
> I re-tested with both patches applied, but still no help.

OK, thanks.

> BTW, why do you call that patch "vmark" fix? :)
> I just wonder what "vmark" means.

Oh, that's volanomark.  It put itself in directory vmark2.5.0.9, so it's
vmark ;-)

	-Mike

