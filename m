Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbXICJsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbXICJsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 05:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXICJsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 05:48:35 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3984 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbXICJsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 05:48:35 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <dhazelton@enter.net>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Fwd: That whole "Linux stealing our code" thing
Date: Mon, 3 Sep 2007 02:48:00 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEDKGJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <200709022311.33534.dhazelton@enter.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 03 Sep 2007 02:48:43 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 03 Sep 2007 02:48:44 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Mr. Floeter *CAN* request that his code be removed from said fork
> - his code
> is solely licensed (AFAICT and IIRC) under the BSD/ISC license
> and was only
> covered by the dual-license because it was integrated into a work that
> carried said dual-license. (I'm not sure how well such a revocation would
> work in reality, but it is Mr. Floeters right.)...

No. Neither the BSD license nor the GPL license permit you to revoke rights.
Mr. Floeter's code is still available under the BSD/ISC license. The BSD
license does not require you to make derived works available under a BSD
license. *His* code is still available under a BSD/ISC license, of course,
but the changed code is not.

Read the BSD license. It does not require changes to be made available under
a compatible license. This is the main difference between the BSD and GPL
licenses.

Note that it would be an error to remove the BSD license text, as the BSD
license requires you to keep it and you still need the BSD license to grant
you distribution rights to the original work. However, the license does not
apply to protectable aspects of the code not placed under the BSD license by
their original author, and it is important to add a note to that effect.

DS


