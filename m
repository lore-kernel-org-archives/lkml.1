Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773Ab0ALC2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0ALC2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743Ab0ALC2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:28:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:35697 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753240Ab0ALC2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:28:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/tmgAZrYLtKm8uzphEgZgWwlQVgBWdZoazqm/acB
	4kA+qxED+OkO4A
Subject: Re: [Bug #15034] volano ~30% regression
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <201001112108.24858.rjw@sisk.pl>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
	 <omZ8aBZReyD.A.BXG.2MlSLB@chimera>
	 <1263192758.6444.9.camel@marge.simson.net> <201001112108.24858.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 12 Jan 2010 03:28:38 +0100
Message-Id: <1263263318.5905.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 21:08 +0100, Rafael J. Wysocki wrote:
> On Monday 11 January 2010, Mike Galbraith wrote:
> > On Sun, 2010-01-10 at 23:32 +0100, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > (either way).
> > 
> > A verified fix for this one is in the pipe.
> 
> OK, thanks for the update.
> 
> A link to that fix would be appreciated. :-)

One link, coming up.

http://patchwork.kernel.org/patch/70623/

	-Mike

