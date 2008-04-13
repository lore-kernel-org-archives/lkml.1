Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYDMJzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYDMJzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbYDMJzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:55:12 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:37793 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYDMJzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:55:11 -0400
Message-ID: <4801D82C.7000901@panasas.com>
Date: Sun, 13 Apr 2008 12:53:48 +0300
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andy Whitcroft <apw@shadowen.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SL Baur <steve@xemacs.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] checkpatch: relax spacing and line length
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <47FCB458.3070403@panasas.com> <20080409132548.GM17915@shadowen.org> <47FCF6AF.8010703@panasas.com> <20080412002652.GM9785@ZenIV.linux.org.uk>
In-Reply-To: <20080412002652.GM9785@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 12, 2008, 3:26 +0300, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Wed, Apr 09, 2008 at 08:02:39PM +0300, Benny Halevy wrote:
> 
>> I'm not sure what "two space change" proposal this Steve referred to
>> and his rejection is based on not-to-sound aesthetic grounds.
>>
>> The motivation behind our proposal is more than just aesthetic.
>> I believe that using tabs for indent and then spaces for alignment
>> is functionally better, works for everybody, and will eventually result
>> in a more readable code over time, hopefully leading to fewer bugs.
> 
> Sorry.  I'm not going to change perfectly working editing habits *or* to patch

That's working well for you but apparently not so well for everybody else.

> nvi to satisfy an annoying wunch of bankers.  HAND, GAFL.
> --

Thanks for the insightful and mature comment, Al.

I really hate to spend more time on this topic but folks did find merits in it.
There's no need to change anybody's editing habits if we allow this indentation
style in the CodingStyle document and in checkpatch.pl in addition to the
existing convention.

Benny

