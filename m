Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbXD1LwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbXD1LwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbXD1LwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:52:14 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756264AbXD1LwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:52:13 -0400
Date: Sat, 28 Apr 2007 04:51:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cbou@mail.ru
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <gregkh@suse.de>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-Id: <20070428045148.9f1ba191.akpm@linux-foundation.org>
In-Reply-To: <20070426232902.GA10423@zarina>
References: <20070426232902.GA10423@zarina>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 03:29:02 +0400 Anton Vorontsov <cbou@mail.ru> wrote:

> To not confuse with David own battery-2.6 repository, it's called
> battery2-2.6, and can be found here:
> 
> http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=summary
> 
> You can get it using "git clone --reference linux-2.6 \
> git://git.infradead.org/users/cbou/battery2-2.6.git" command.

i386 `make allmodconfig':

ERROR: "battery_is_external_power_supplied" [drivers/battery/ds2760_battery.ko] undefined!
ERROR: "battery_unregister" [drivers/battery/ds2760_battery.ko] undefined!
ERROR: "battery_register" [drivers/battery/ds2760_battery.ko] undefined!
ERROR: "battery_status_changed" [drivers/battery/ds2760_battery.ko] undefined!
