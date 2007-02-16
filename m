Return-Path: <linux-kernel-owner+w=401wt.eu-S1750865AbXBPLmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750865AbXBPLmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 06:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXBPLmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 06:42:09 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:38331 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbXBPLmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 06:42:08 -0500
Date: Fri, 16 Feb 2007 12:41:41 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jon K Hellan <jon.kare.hellan@uninett.no>
cc: linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <45D57CF5.70503@uninett.no>
Message-ID: <Pine.LNX.4.61.0702161232530.27120@yvahk01.tjqt.qr>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> 
 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> 
 <20070215061149.GE15654@redhat.com>  <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
  <20070215165339.GB5285@thunk.org>  <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
  <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com> 
 <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com> 
 <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz> 
 <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com>
 <1171617170.5835.101.camel@frg-rhel40-em64t-03> <45D57CF5.70503@uninett.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 16 2007 10:44, Jon K Hellan wrote:
> Xavier Bestel wrote:
>> On Thu, 2007-02-15 at 21:48 -0800, v j wrote:
>> > We only get crap because no one here yet knows how to interpret
>> > proprietary modules loaded into the kernel.
>> 
>> The proprietary modules where only a tiny wrapper is linux-specific and
>> the rest is cross-platform are in a grey area, yes.
>> But your modules, written specifically for linux but distributed as
>> binary-only, are specifically what the people choosing the GPL want to
>> avoid. They are a derivative work, and are, as such, illegal under the
>> GPL.
>
> If they are a derivative work, they are illegal under the GPL. However, it is
> not clear that their being written specifically *for* Linux is sufficient to
> make them derivative works *of* Linux.

	Who knows, perhaps there's a public domain interface that wraps linux
kernel function calls into bsd functions, so you can always "successfully"
argue the source code is not only for Linux. However, I think that precompiled
.ko files are _much more_ tied to Linux (in short, supporting your point) plus
a specific architecture.


Jan
-- 
