Return-Path: <linux-kernel-owner+w=401wt.eu-S1946030AbXBBSjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946030AbXBBSjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 13:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946031AbXBBSjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 13:39:16 -0500
Received: from tag.witbe.net ([81.88.96.48]:38842 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946030AbXBBSjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 13:39:16 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Jan Engelhardt'" <jengelh@linux01.gwdg.de>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Andrew Morton'" <akpm@osdl.org>,
       "'Jon Masters'" <jonathan@jonmasters.org>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>
Subject: RE: [PATCH] Ban module license tag string termination trick
Date: Fri, 2 Feb 2007 19:37:27 +0100
Organization: AS2917.net
Message-ID: <01b701c746f9$333c9d80$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdG3M2hx7X+j4gGRs2VLrd71Kc9OwAHE+4w
In-Reply-To: <Pine.LNX.4.61.0702021610510.26531@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> MODULE_IS_UNDER_GPL_LICENSE("yes\0 but only this .c file");
> 

MODULE_IS_UNDER_GPL_LICENSE(0)
(integer, not string).

Paul

