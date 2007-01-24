Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbXAXPGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbXAXPGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXAXPGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:06:25 -0500
Received: from web52902.mail.yahoo.com ([206.190.49.12]:42917 "HELO
	web52902.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751925AbXAXPGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:06:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=m48hJ1sPj6IDw17crw0Bn+HCfPcZ3I7Y/TmBxRcbb4isYmWX3n0HxaizFMtfG++KgAjiFDqBjPRVr5HAiAnKBQBfXpGSqOwKa0ubnVEQMAUopL9RRjIv8tIF9q5iWNWmn/jAmDkZP4p1pY3LJ/NJ7tOHcxSo7vylr3OJX3M+O4A=;
X-YMail-OSG: KJve14IVM1n17Egj.i6KKSduYbbbI9eRmaUkHm8.R8A1jbyYbyZabZ.4PvO21gqNcuewo_xUnBzzEoBKryhhrtofJqk8lk9D5.npyGEM83l2fwSHhgTAlQL7QEeeKpXN6CphZ.BIFyOoanI-
Date: Wed, 24 Jan 2007 15:06:23 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.18-stable release plans?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <249539.3227.qm@web52902.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That's surely no reason to dump 2.6.19.x, you'll find the occasional
> such report on every(?) release since page mapcount went into 2.6.7.

This was the only time I've seen it, before or since.

> Oftentimes it's bad RAM (try memtest86)

There is nothing wrong with my RAM. I tested it quite extensively when I upgraded to 2 GB.

> sometimes it's a bad driver (probably the case for the tainted P report appended
> to your untainted one), sometimes it's unidentified memory corruption.

But MY kernel is clearly untainted. So what other explanation is there apart from a kernel bug?

Cheers,
Chris



		
___________________________________________________________ 
All New Yahoo! Mail – Tired of unwanted email come-ons? Let our SpamGuard protect you. http://uk.docs.yahoo.com/nowyoucan.html
