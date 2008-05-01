Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbYEAPGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbYEAPGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760865AbYEAPGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:06:05 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1790 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761990AbYEAPGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:06:03 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 11:06:03 EDT
From: "David Schwartz" <davids@webmaster.com>
To: "pradeep singh rautela" <rautelap@gmail.com>, <hjk@linutronix.de>
Cc: "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>
Subject: RE: [Q]Can a file be dual licensed in upstream kernel?
Date: Thu, 1 May 2008 07:59:54 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEBJMFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20080429062627.GA3195@local>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 01 May 2008 08:00:55 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 01 May 2008 08:00:56 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> In my _personal_opinion_, dual licensing gives you the right to choose
> between two licenses.

Dual licensing gives every recipient both licenses from the original author.
You can choose which license you will obtain rights from.

> If a file is dual licensed BSD/GPLv2, anybody
> (including yourself) is free to get rid of the BSD part and make it
> GPLv2 only.

Really? Which license or law gives you the right to change the licensing
terms on code you didn't write? At least in the United States, you cannot
change the licensing terms on someone else's code absent a written
re-licensing agreement.

Every recipient of dual-licensed creative works or elements of works can
obtain rights from either license. You only need comply with the
requirements of one of the licenses to obtain rights from it. If you
redistribute the code, every recipient gets the same rights you got from the
original authors of every creative element you redistribute.

The distributor can choose by which license he obtains the right to
distribute, but this has no effect on the license his recipients get! (This
should be common sense. If you buy a music CD from Amazon, do you think how
Amazon got the right to sell you the CD should have an effect on what you
can do with the CD?)

You can remove the BSD license notice, because the GPL gives you that right
(it only requires you to retain notices that refer to "this License", the
GPL, not other licenses). But removing a license *notice* does not change
the license. (That should be common sense too.)

If you modify the code, of course, they only get the rights you choose to
give them to anything you added (assuming it is sufficiently creative to
warrant copyright protection). Nobody can grant other people rights to your
code that you don't want to grant. But you cannot add or subtract licensing
terms to code you did not write (at least, neither the GPL nor the BSD
license give you this right). The license grant is direct from the original
author to the ultimate recipient.

The GPL makes this explicit in section 6, "Each time you redistribute the
Program (or any work based on the Program), the recipient automatically
receives a license from the
original licensor to copy, distribute or modify the Program subject to these
terms and conditions. You may not impose any further restrictions on the
recipients' exercise of the rights granted herein."

The BSD license does not make this explicit, but there is no other legal way
it could work. The BSD license, of course, permits you to impose further
restrictions on the recipients' exercise of rights to the modifications you
made while the GPL does not.

DS


