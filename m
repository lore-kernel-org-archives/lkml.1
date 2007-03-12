Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXCLJ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXCLJ7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965481AbXCLJ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:59:40 -0400
Received: from tag.witbe.net ([81.88.96.48]:54759 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965472AbXCLJ7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:59:30 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Mon, 12 Mar 2007 10:58:31 +0100
Organization: AS2917.net
Message-ID: <008d01c7648d$0108d1b0$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <45F509A7.8030705@gmail.com>
Thread-Index: AcdkfSbr6MEFhxUMRIGF0OVN1mzJCwAD5+Yw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > That sounds a quite expensive solution ;)
> 
> You should be able to just move the drive attached at ata1 to ata2.
> Please report whether that works.

I'll try to find an unused disk... As I said, these ports are part of
Asus EZRaid solution, and i'd prefer this piece of code not to try to
write anything on the disk ;)

... but I should find a disk without too much problem.

Paul

