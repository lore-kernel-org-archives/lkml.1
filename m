Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbXICCCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbXICCCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbXICCBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:01:33 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2192 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXICCBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:01:30 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Fwd: That whole "Linux stealing our code" thing
Date: Sun, 2 Sep 2007 19:01:18 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOECFGJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070901213052.530483c3@the-village.bc.nu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 02 Sep 2007 19:02:04 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 02 Sep 2007 19:02:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox wrote:

> The ath5k C file in question (not the headers) seems to give recipients
> permission to further convey the work under a choice of two licences.

Correct.

> It doesn't say they must redistribute under both.

Correct. They need the right to redistribute the work, and they may obtain
that right from either license.

> So I appear to have a
> right to convey the work under the GPL to a third party, who from me
> receives no right to use it except under the GPL.

Here's where your train goes off the rails. They do not receive any right to
use it from you. They receive a license to use it under the GPL from the
original author. Please read GPL section 6.

"  6. Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions.  You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties to
this License."

The GPL does not give you *any* right to extend anyone a license to code you
did not author. (Nor can it as such an extension would have to be done in
writing in most countries.) When you distribute a GPL'd work, the right to
use every creative element in that work is licensed to the recipients
directly from their respective authors. Under no circumstances does the GPL
ever give you the ability to license someone else's work to a third party.

>  * Alternatively, this software may be distributed under the terms of the
>  * GNU General Public License ("GPL") version 2 as published by the Free
>  * Software Foundation.
>
> The choice appears to be delegated to the recipient very clearly and
> very specifically by the licencing on the file. It does not say that I
> must convey the work under both licences. It quite specifically says I may
> convey the work under whichever of the two I prefer (and probably both if
> I wish). Clearly if that had not been the intent it would not have
> included the clause giving the choice.

Either license can grant you the right to distribute it, but how you get the
rights to distribute has *NO* effect on the recipient. They receive a lawful
copy and any rights the original author grants them under a license from
that original author. You have no power to grant or modify rights to the
original work.

This is a common misunderstanding.

Note that you may remove the text of either license from a dual-licensed
file and redistribute under the other license because neither license
requires you to retain the other license and both licenses give you the
right otherwise to modify as you wish. But the removal of a license from a
file has no effect on the grant of license. Your recipients still get a dual
license to those protectable elements in the file that were placed under a
dual license. You cannot stop the automatic grant.

DS


