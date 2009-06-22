Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZFVRyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZFVRyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZFVRyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:54:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:13963 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbZFVRyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:54:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,270,1243839600"; 
   d="scan'208";a="157219365"
Subject: Re: iwl3945 in 2.6.31-rc0: ad-hoc mode broken?
From: reinette chatre <reinette.chatre@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090622174002.GD21299@elf.ucw.cz>
References: <20090619222431.GA2398@elf.ucw.cz>
	 <1245692380.24303.494.camel@rc-desk>  <20090622174002.GD21299@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 11:01:26 -0700
Message-Id: <1245693686.24303.515.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 10:40 -0700, Pavel Machek wrote:
> On Mon 2009-06-22 10:39:40, reinette chatre wrote:
> > Hi Pavel,
> > 
> > On Fri, 2009-06-19 at 15:24 -0700, Pavel Machek wrote:
> > > Hi!
> > > 
> > > I tried using ad-hoc mode (against t-mobile G1) on -rc0, and was
> > > unsuccessful -- never got dhcp. I had to reboot back to
> > > 2.6.30... Should I try it few more times or is something broken?
> > > 
> > > (Also wifi LED stopped working on x60, but that's older issue).
> > > 
> > 
> > Are you testing Linus's repo here? Should we not maybe wait with testing
> > until -rc1 is released?
> 
> WTF? Yes, I am testing Linus' tree (hence 2.6.31-rc0). I thought
> 2.6. stable series is expected to work at all times, and it is bug if
> it does not (otherwise git bisect is useless). Did you intentionally
> break the tree or what?

No. We include adhoc testing in our weekly tests on different hardware
(3945) and have not seen any issues. We have not yet done any official
testing on 2.6.31 as we usually do so only after -rc1 is released.

>  Or do you have fixes pending?

All our fixes targeting 2.6.31 have been pushed. We do not have anything
else pending.

This is our first report of an issue in 2.6.31 and we will take a look.

Reinette



						


