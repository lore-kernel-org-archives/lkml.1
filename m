Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbXIQBlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbXIQBlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 21:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbXIQBlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 21:41:09 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1852 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbXIQBlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 21:41:08 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <tytso@thunk.org>
Cc: <bunk@kernel.org>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Wasting our Freedom
Date: Sun, 16 Sep 2007 18:40:21 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEFOGNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070917011914.GE5502@thunk.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 16 Sep 2007 18:41:07 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 16 Sep 2007 18:41:09 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Theodore Tso wrote:

Essentially, I agree with you. My only disagremeent with you is that I think
the problem starts sooner:

> However, consider a file which was originally BSD licensed.  Now
> suppose it is modified (i.e., a derived work was created) and another
> author slaps on a BSD/GPL dual notice.  That's fine, so far; the BSD
> license on the original file permits that.  The new code is licensed
> under either BSD or GPL (user's choice), and the original code is
> under the BSD license, which is compatible with the GPL code, so
> regardless of whether the user choose the BSD or GPL license.

I would argue that it's really not so fine so far. You need to careful to
make sure that anybody who receives this file understands that they *must*
comply with the BSD license in addition to the GPL.

There choices are not "BSD or GPL" they are "BSD or BSD+GPL". They may
choose to comply with just the terms of the BSD license, or they may choose
to in addition require those who make further derivatives to comply with the
GPL *as* *well*.

But this is not really dual-licensed as you cannot choose just the GPL.

DS


