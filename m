Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbYGAUm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbYGAUm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761234AbYGAUms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:42:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53092 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761175AbYGAUmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:42:46 -0400
Message-ID: <486A96C1.2020106@firstfloor.org>
Date: Tue, 01 Jul 2008 22:42:41 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <20080701063133.GC16642@elte.hu> <4869D4A3.3020000@zytor.com> <200807012239.44105.rjw@sisk.pl>
In-Reply-To: <200807012239.44105.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I have tested it on the nx6325 (64-bit) on top of the today's linux-next.  It
> works fine for me.

Could a few more people with different laptops please test too?

-Andi
