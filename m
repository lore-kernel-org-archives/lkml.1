Return-Path: <linux-kernel-owner+w=401wt.eu-S968803AbXFHNGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968803AbXFHNGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938171AbXFHNG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:06:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937143AbXFHNG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:06:28 -0400
From: Olaf Dietsche <olaf.dietsche@olafdietsche.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
References: <878xb35sje.fsf@goat.bogus.local> <200706041013.49428.rjw@sisk.pl>
	<87hcpnpt4k.fsf@goat.bogus.local> <200706042302.45628.rjw@sisk.pl>
	<87y7ivo86z.fsf@goat.bogus.local>
Date: Fri, 08 Jun 2007 15:07:27 +0200
In-Reply-To: <87y7ivo86z.fsf@goat.bogus.local> (Olaf Dietsche's message of
	"Thu, 07 Jun 2007 21:50:28 +0200")
Message-ID: <877iqeoar4.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX18juOz+O47eD7eoaAvx1fTlZDSJVXhp3Ub27Hm
 gawn6uZvJ5atfVRCaXMI4eroEgGH8boxQRh6uJ2DFnXylSIVdM
 MI+0MUaT7c9igdOi7yNpg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de> writes:

> I installed the nvidia.ko (1.0-9755) kernel module and now the machine
> comes back to life. Although the screen stays black as before, I can
> type blindly "shutdown -r now" or ssh into the laptop.

Here's an update: when I additionally install the complete nvidia
package, including the binary X server modules, my screen becomes
active on resume.

This is not really satisfactory, since my console stays black. Anyway,
this is another step forward, nonetheless.

Regards, Olaf.
