Return-Path: <linux-kernel-owner+w=401wt.eu-S1759162AbYDNGIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162AbYDNGIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYDNGIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:08:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:41242 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbYDNGIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:references:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:in-reply-to:x-mimeole:thread-index;
        b=w0LD1G/ct8AuVLNUsVHoRr8RaxJVki/0laDpiUrTqOU33//fKYMUZPaSpfr9fn89oFVlVi3nV6o74RCYdtWoHc3xp3kPdf7yr11HQkS25gu4R1Macmm4rpJNa9B9oipv91C2Vi7eVreSyUlJKiZ4z3A+oL5ZuhoWxyQDQgAoQZs=
From: "Alexia Death" <alexiadeath@gmail.com>
To: <linux-kernel@vger.kernel.org>
References: <200804132326.07713.alexiadeath@gmail.com> <200804140245.33171.arnd@arndb.de>
Subject: RE: Problem: non-SDHC 2GB SD cards are unreadable
Date: Mon, 14 Apr 2008 09:08:28 +0300
Message-ID: <002401c89df5$f5dd2b80$087811ac@encnet.ead.ems>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <200804140245.33171.arnd@arndb.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AcidyN+SBWanN1KNQW2MUUHvK75CPAALI6aA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems  this issue is a "wont fix" even tho its quite common since its a
reader problem. I finally found this today:
http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg56667.h
tml The reader needs to be aware of the hack these SD cards do to work and
apparently this and many other simpler ones are not.

Thanks for listening,
Alexia.

