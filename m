Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbXFBAHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbXFBAHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXFBAHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:07:40 -0400
Received: from neon.samage.net ([85.17.153.66]:44319 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbXFBAHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:07:39 -0400
Message-ID: <3499.81.207.0.53.1180742856.squirrel@secure.samage.net>
In-Reply-To: <87hcpr2ubl.fsf@goat.bogus.local>
References: <878xb35sje.fsf@goat.bogus.local>
    <200706012237.17375.rjw@sisk.pl> <87k5un4bwk.fsf@goat.bogus.local>
    <200706012340.54394.rjw@sisk.pl> <87hcpr2ubl.fsf@goat.bogus.local>
Date: Sat, 2 Jun 2007 02:07:36 +0200 (CEST)
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
From: "Indan Zupancic" <indan@nul.nu>
To: "Olaf Dietsche" <olaf+list.linux-acpi@olafdietsche.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "pm list" <linux-pm@lists.linux-foundation.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 63767ed6f001c63471f2cde26909bd9c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, June 2, 2007 00:17, Olaf Dietsche wrote:
> It doesn't work. I tried all options "s2ram -f (-s, -p, -m, -r, -a 1, -a 2,
> -a 3)" one after the other.
>
> Since the screen (or any other device) works without problems, when I
> skip acpi_enter_sleep_state(), I don't think it's screen related.

I use "s2ram -f -p -s -a 3", maybe you need some exotic combination too.

Greetings,

Indan


