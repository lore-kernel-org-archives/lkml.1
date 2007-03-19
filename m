Return-Path: <linux-kernel-owner+w=401wt.eu-S965777AbXCSHsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965777AbXCSHsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 03:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965763AbXCSHsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 03:48:35 -0400
Received: from tag.witbe.net ([81.88.96.48]:57293 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965777AbXCSHse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 03:48:34 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Mon, 19 Mar 2007 08:48:00 +0100
Organization: AS2917.net
Message-ID: <005501c769fa$ee402470$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <45FE137D.8000300@gmail.com>
Thread-Index: Acdp4FMIXWNfFZcZRjSL5NOboINl+wAGlHsg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh... that's just weird.  It seems you'll have to continue 
> boot with the
> timeouts for the time being.  Sorry about that.

Would you agree to a patch to add a kernel boot parameter to skip some
ata ports ?
I found some archives refering to some "ataX=noprobe", but it seems
to have no effect, and I'd like to resurrect it for libata, at least to
help me support my configuration ?
If no, I'll just cook it for me, without posting it...

Regards,
Paul

