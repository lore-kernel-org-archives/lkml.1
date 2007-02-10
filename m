Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbXBJWAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbXBJWAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXBJWAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:00:33 -0500
Received: from tag.witbe.net ([81.88.96.48]:57983 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbXBJWAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:00:33 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Alan'" <alan@lxorguk.ukuu.org.uk>
Cc: "'Robert Hancock'" <hancockr@shaw.ca>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: AHCI - remove probing of ata2
Date: Sat, 10 Feb 2007 22:59:41 +0100
Organization: AS2917.net
Message-ID: <00da01c74d5e$c446d730$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070210203652.203f648a@localhost.localdomain>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdNUUsKKqkuhVMXTS6pEPYDkmW/CQADV1Hw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> This looks like the problems that hopefully the patches from Tejun and
> from Mark Lord cured (the delay after reset and the task file clear)

Any chance I can find this patch(es) and try them ?
 
> > Also, I've seen a :
> > 
> > ata1: Spurious SDB FIS during NCQ issue=0x0 SAct=0x7ff8001f
> > FIS=004040a1:00040000
> > 
> > What's this ? Is it really bad or just a warning ???
> 
> It's one Tejun stuck logging in for in order to investigate further.

OK, will wait a little bit ;)

Regards,
Paul

