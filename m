Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbXCMFYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbXCMFYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbXCMFYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:24:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:15499 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbXCMFYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WcCeTq+vaE6j/vSqiGJOaZO+DOJ1X14GpcDkQgRqnr17k16qiWjRBF0eKIHSyyVwqc4kOf+llEYwBVpUdEnoGsIeg1vJng2H7KoDIqSEzpm9VDlzSIonnGuMNAYaLq6FtYLL8GEsdoCAhDT19I4bo6XN+GgLJayfelLqtWc2+Cg=
Message-ID: <9debc4410703122224n5def90e7g4767b95b176941c0@mail.gmail.com>
Date: Tue, 13 Mar 2007 10:54:08 +0530
From: "Maxin John" <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Need help on mach-ep93xx
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one question mach-ep93xx.

In  EP93xx  IRQ handling part in core.c,  the 2.6.19.2 kernel and
newer  kernels are configuring the 16 interrupts of the ports A & B
together. The code is not using the  interrupt capability  of the port
F which can provide 3 interrupts.

 Why the port F is not configured for interrupts ?

Thanks in advance,

Maxin B. John
