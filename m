Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbXFAVMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbXFAVMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762858AbXFAVMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:12:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:61964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762370AbXFAVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:12:04 -0400
From: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
References: <878xb35sje.fsf@goat.bogus.local> <200706012237.17375.rjw@sisk.pl>
Date: Fri, 01 Jun 2007 23:12:27 +0200
Message-ID: <87k5un4bwk.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX189IJTVxxo1bvlhDyvKR5H3hjD8X44XogRXFYu
 1KXXrkqTSCgSA80AO1XBqxWl5loxtYcetvfcUKoxFHeNKBd51/
 js7PfqvpXuqXe28KG6Kow==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Friday, 1 June 2007 22:27, Olaf Dietsche wrote:
>> When I resume, everything seems to come up (fan becomes busy, disk and
>> dvd spin up for a short time),
>
> Hmm, what about the screen?

When the laptop is dead, screen remains black.

When I skip acpi_enter_sleep_state(), the screen works like everything
else.

Regards, Olaf.
