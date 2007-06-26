Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbXFZWqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbXFZWqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXFZWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:46:12 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2872 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbXFZWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:46:11 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Tue, 26 Jun 2007 15:45:28 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEEIEOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <Pine.LNX.4.64.0706261307310.23285@asgard.lang.hm>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 26 Jun 2007 15:45:46 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 26 Jun 2007 15:45:48 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


david@lang.hm wrote:

> this sounds like a step backwards, you may not have the sources at that
> point if you were relying on the other site to host them.

You would then be violating the GPL, under any version. The GPL is quite
clear that being unable to comply with it means you do not get the benefits
it offers rather than excusing you from meeting its requirements.

You *MUST* have the source code in order to distribute it on request. You
cannot ship GPL'd works without offering source code just by arranging it
(deliberately or accidentally) so that you don't have the source code.

> and by the way, internet access never was a barrier that could stop
> someone from obtaining them, the only issue was you hosting the source vs
> someone else hosting the source.

The GPLv2 never specified one way or the other.

If you do allow someone else to host them, you are responsible for making
sure they remain available for at least three years from the last time you
used them as an offer. Should they stop distributing, you would be violating
the GPL. Nothing in the GPL says you can't rely on third parties for your
GPL compliance. Of course, this could be a very risky thing to do. However,
there is no GPL violation so long as they do in fact remain operational for
three years from the last time you distributed.

In fact, a third party is no more risky than any other setup. Any company
can go out of business within the three-year period after distribution.
There are many real-world cases where a third party having the source is
actually more likely to result in actual GPL compliance than the
distributor. (Consider a fly-by-night company selling Fedora binary
distributions burnt to CDROM on the stop for $1 on a street corner.)

One way to avoid this problem is to maintain your own web page that links to
the third party's download. You would have to host the sources yourself if
you couldn't make other arrangements at any point during the three year
period.

This is no different from any other case where the offer is not honored. If
the offer is not honored in a case where the GPL requires that it be, the
GPL is being violated.

DS


