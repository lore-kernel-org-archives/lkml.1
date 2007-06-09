Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbXFIHFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbXFIHFG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXFIHE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:04:56 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4141 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbXFIHE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:04:56 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sat, 9 Jun 2007 00:04:17 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEFCEHAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <466A3EC6.6030706@netone.net.tr>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 09 Jun 2007 00:04:39 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 09 Jun 2007 00:04:41 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But; if the Linux kernel should Dual-Licensed (GPL V2 and GPL V3), it
> will allow us the both worlds' fruits like code exchanging from other
> Open Source Projects (OpenSolaris etc.) that is compatible with GPL V3
> and not with GPL V2 and of course the opposite is applicable,too.

That is a misleading claim. While being dual-licensed would make it either
for other projects to adopt Linux code, it would have three downsides:

1) If Linux code were adopted into other projects that were not
dual-licensed, changes could not be imported back into Linux unless the
changes were dual-licensed which is not likely when the contributions are
made to a project that's not dual-licensed.

2) Linux could no longer take code from other projects that are GPL v2
licensed unless it could obtain them under a dual license.

And, last and probably most serious:

3) Linux derivatives could be available with just a GPL v3 license and no
GPL v2. license if the derivers wanted things that way.

DS


