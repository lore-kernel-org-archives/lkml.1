Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbYBYUvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbYBYUvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759648AbYBYUvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:51:02 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:60346 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759581AbYBYUu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:50:59 -0500
Message-ID: <47C32A1D.8030604@suse.de>
Date: Mon, 25 Feb 2008 23:50:37 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on
 thinkpad T61p
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>	 <47C31A1E.7080305@suse.de> <8f53421d0802251239h6b872d94w677995789990e31b@mail.gmail.com>
In-Reply-To: <8f53421d0802251239h6b872d94w677995789990e31b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> Did you guys stop accepting reports by mail?
> I hope not.
It is easier to track bug information in bugzilla.
If you for some reason do not wish to create a bug report,
I can do it for you. You only need to provide acpidump.
> 
>> and attach acpidump?
> 
> I'll see if I can get acpidump output - in which state do you want it?
> Right after boot on the broken kernel?
acpidump output does not change over time, you could get it even with some other kernel.

