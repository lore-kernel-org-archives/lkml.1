Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbXFNT3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbXFNT3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXFNT33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:29:29 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2888 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbXFNT32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:29:28 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 12:28:34 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEFCEJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070613180953.GA18512@delft.aura.cs.cmu.edu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 14 Jun 2007 12:29:08 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 14 Jun 2007 12:29:09 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The GPL applies to "the Program" which in this case is the Linux kernel
> as a whole and it in fact does indicate a specific version. All code
> submitted and included in this program has has been submitted with the
> understanding that the work as a whole is specifically licensed as
> GPLv2. Some authors have granted additional rights, such as dual BSD/GPL
> or GPLv2 and later and explicitly added such a notice.

Since the Linux kernel as a whole does not have a single author, it is
impossible to license it as a whole. Nobody has the authority to do that.
(The GPL is not a copyright assignment type license.)

Fortunately, the GPL clears this up:

"Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions.  You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties to
this License."

Linus cannot impose any further restrictions on the recipients' exercise of
the rights granted.

When you download a copy of the Linux kernel, you do not receive one license
because nobody could grant you one license. You receive a logically separate
license from each original licensor. You receive from Linus only a license
to his contributions.

Note that you cannot take a GPLv2+ work and redistribute it as GPLv3 only.
You can license your contributions as GPLv3 only of course. However, each
recipient still receives a GPLv2+ license to the parts that were originally
licensed that way. The people you distribute the work from receive licenses
from the original licensors to those parts, and you have no right to modify
that license. (See GPL section 6, quoted above.)

DS


