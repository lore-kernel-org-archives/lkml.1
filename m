Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZLYV6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZLYV6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 16:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbZLYV6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 16:58:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39731 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863AbZLYV6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 16:58:39 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Regression in module wmi since 2.6.32 (bisected to commit 1caab3c)
Date: Fri, 25 Dec 2009 21:58:30 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.31.5; KDE/4.3.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
References: <4B352513.90302@lwfinger.net> <200912252056.08436.carlos@strangeworlds.co.uk> <4B353035.4050208@lwfinger.net>
In-Reply-To: <4B353035.4050208@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912252158.31127.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 December 2009 21:35:49 Larry Finger wrote:
> Should I attach the files DSDT.dat, acpidump.out, or DSDT?

DSDT from /proc/acpi/dsdt will do fine for my purposes.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
