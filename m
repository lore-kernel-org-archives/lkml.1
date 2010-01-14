Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634Ab0ANU0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab0ANU0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610Ab0ANU0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:26:53 -0500
Received: from server109i.appriver.com ([72.32.253.93]:3541 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756737Ab0ANU0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:26:52 -0500
X-Policy: GLOBAL - intcomgrp.com
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G113 G114 G115 G116 G120 G121 G132 G219 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] net: at91_ether.c - Allow transmitter interrupt to be handled first in ISR
Date: Thu, 14 Jan 2010 15:28:38 -0500
Message-ID: <3DBBD805E3BA064A87F551C0E8BD367402897539@MAILSRV.intcomgrp.com>
In-Reply-To: <20100113.173253.223656114.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] net: at91_ether.c - Allow transmitter interrupt to be handled first in ISR
Thread-Index: AcqUubmOl/m1delnRjWCeXIaLhRbGgAm71GA
References: <3DBBD805E3BA064A87F551C0E8BD36740289748A@MAILSRV.intcomgrp.com> <20100113.173253.223656114.davem@davemloft.net>
From: "James Kosin" <JKosin@intcomgrp.com>
To: "David Miller" <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       <eric.dumazet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks David,

I'm checking out the latest git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
With git now...

A few items:
	a)  Is it OK to use git-diff to build a patch file?  Or does everyone still prefer
	    diff?

	b)  I'm going to try and test also; since, I do have an active platform I
	    can test on.  Are there any other developers using the ARM that may be able
	    to provide some feedback?  Eric Dumazet had some interesting comments
	    but, none of the original people in the file are around anymore I'm afraid.
	    That or they really don't want to be contacted.

Thanks Again,

James Kosin
