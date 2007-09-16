Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXIPWUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXIPWUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 18:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbXIPWUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 18:20:43 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2922 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbXIPWUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 18:20:42 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Cc: <hannah@schlund.de>
Subject: RE: Wasting our Freedom
Date: Sun, 16 Sep 2007 15:19:41 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEFEGNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <20070916203926.GA17863@schlund.de>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 16 Sep 2007 15:20:31 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 16 Sep 2007 15:20:31 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> JFTR, I do *not* think that that assessment was questionable. Unless the
> dual-licensing *explicitly* allows relicensing, relicensing is forbidden
> by copyright law. The dual-licensing allows relicensing only if that's
> *explicitly* stated, either in the statement offering the alternative, or
> in one of the licenses.
>
> Neither GPL nor BSD/ISC allow relicensing in their well-known wordings.
>
> If you think that's questionable, you should at least provide arguments
> (and be ready to have your interpretation of the law and the licenses
> tested before court).

Nobody is relicensing anything, ever.

If the author licenses a work under the GPL only, then that is forever how
that work is licensed. If an author licenses a work under the BSD, then that
is forever how that work is licensed. Same for a dual license. This applies
until the copyright expires or the author offers the code under some other
license.

Nobody ever relicenses anything, ever.

If I give you a copy of a work covered by the GPL, the BSD, a dual-license,
or whatever, you get a license to every protectable element in that work
from the original author of that element.

Nobody ever relicenses anything, ever. Nobody ever modifies anybody else's
license, ever.

If you take work that's under a dual-license and remove one license notice
from it when you create a derivative work, every recipient of that
derivative work still receives a dual license from the original author to
every protectable element still in the distributed work.

The GPL is explicit about this in section 6. The BSD license is not, but
it's the only way such a license could work.

There are really only two ways you can screw up.

1) You can take GPL-only bits and put them in BSD or dual-licensed code.
(The GPL prohibits this.)

2) You can remove a BSD license notice from BSD-only code. (The BSD license
prohibits this.)

DS


