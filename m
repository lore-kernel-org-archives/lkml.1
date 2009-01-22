Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZAVWCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZAVWCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZAVWCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:02:01 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:6627 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbZAVWCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:02:00 -0500
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: HP accelerometer driver: testers wanted
Date: Thu, 22 Jan 2009 23:01:57 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20090122213139.GD2159@elf.ucw.cz>
In-reply-To: <20090122213139.GD2159@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901222301.57681.elendil@planet.nl>
X-OriginalArrivalTime: 22 Jan 2009 22:01:58.0068 (UTC) FILETIME=[0B94AF40:01C97CDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Pavel Machek wrote:
> It is in latest -mm. Enable CONFIG_SENSORS_LIS3LV02D,
> recompile/reboot. Documentation is in Documentation/hwmon/lis3lv02d
> and Documentation/hwmon/hpfall.c is standalone binary that should park
> your disk (and light a led) as soon as freefall is detected.

My HP 2510p notebook has the device. By chance I activated the driver with 
my last few builds and at least the input device works perfectly with 
the -rc2 kernel (tested with jstest and Tux Racer).

What are the differences relative to -rc2? Looks like it adds the freefall 
device?

Could you please give some additional info what exactly you want tested, 
how to test it, and how safe it is to do the test?

I'd be willing to test, but not if to do so I'd have to throw the notebook 
out of the window... Or even if there is the slightest risk of somehow 
damaging the hard disk.

Cheers,
FJP
