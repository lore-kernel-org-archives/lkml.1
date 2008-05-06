Return-Path: <linux-kernel-owner+w=401wt.eu-S1764931AbYEFQlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764931AbYEFQlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbYEFQli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:41:38 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:34321 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755408AbYEFQlg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:41:36 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 24/56] microblaze_v2: time support
Date: Tue, 6 May 2008 09:36:34 -0700
In-reply-to: <200805061338.24870.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 24/56] microblaze_v2: time support
Thread-Index: Acivbb6QLXvCE8exTkqhtB96Cdz8XwAKLkxg
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <1210033811.5798.188.camel@localhost> <48202C9E.7070800@seznam.cz> <200805061338.24870.arnd@arndb.de>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "Arnd Bergmann" <arnd@arndb.de>, <monstr@seznam.cz>
Cc: "John Williams" <john.williams@petalogix.com>,
       <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
       "John Linn" <linnj@xilinx.com>, <matthew@wil.cx>,
       <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>
X-OriginalArrivalTime: 06 May 2008 16:36:28.0930 (UTC) FILETIME=[557DF620:01C8AF97]
Message-Id: <20080506163629.B6B85EB804F@mail78-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think you're doing a great job on this. Any patch set of this size
that
> has been maintained for a long time outside of the kernel goes through
this
> phase where everyone tells you what to improve, based on their
experience,
> while everything you do right about the patches is just taken for
granted.

I completely agree on this.  I think you're making a huge amount of
progress and spending alot of time incorporating alot of comments from
alot of people.

My main priority is to get as many of the improvements that we've had at
in our git tree, so as to be able to switch to the mainline code as
quickly as possible.  If I keep bringing up the same things it is
because they are barriers to that happening.  I very much want to put a
big ACK on everything, but I'm uncomfortable doing that until I can at
least boot it, and that hasn't happened yet.

> Don't let yourself get discouraged by the negative comments, we're
really
> all just trying to help you do the right thing!

One of the key things that many people take a long time to learn is that
negative comments about code are not a reflection of negativity towards
the person who wrote the code.

Steve


