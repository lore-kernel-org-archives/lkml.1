Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXCEJyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXCEJyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 04:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXCEJyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 04:54:49 -0500
Received: from tag.witbe.net ([81.88.96.48]:58476 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXCEJyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 04:54:47 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Mon, 5 Mar 2007 10:54:30 +0100
Organization: AS2917.net
Message-ID: <00a001c75f0c$47f19750$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <45EBA6E6.10907@gmail.com>
Thread-Index: Acde5QPx9/vf518JRze78q69awI9XwAJx2HQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Your drive has some issues with NCQ and is scheduled to be blacklisted
> such that it isn't enabled.  libata used to ignore the 
> condition but now
> considers it NCQ protocol violation and fails all pending commands.

OK, do you need an hdparm report to fully identify the disk ?
 
> libata EH should turn NCQ off automatically after a few of the above
> errors.  I'd love to see how that actually works in the field (full
> dmesg please).  If it doesn't, it needs fixing.

I'll get you one tonite, I don't have access to the machine right now.

Regards,
Paul

