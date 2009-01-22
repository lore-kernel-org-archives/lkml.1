Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbZAVXX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbZAVXX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZAVXXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:23:50 -0500
Received: from orion.ambsoft.pl ([212.109.144.130]:36703 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbZAVXXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:23:49 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2009 18:23:49 EST
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Pavel Machek <pavel@suse.cz>, kernel-testers@vger.kernel.org
Subject: Re: HP accelerometer driver: testers wanted
Date: Fri, 23 Jan 2009 00:16:42 +0100
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20090122213139.GD2159@elf.ucw.cz>
In-Reply-To: <20090122213139.GD2159@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901230016.43028.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> HP accelerometer driver: testers wanted
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> It is in latest -mm. Enable CONFIG_SENSORS_LIS3LV02D,
> recompile/reboot. Documentation is in Documentation/hwmon/lis3lv02d
> and Documentation/hwmon/hpfall.c is standalone binary that should park
> your disk (and light a led) as soon as freefall is detected.
> 
> For standalone patch, see
> 
> 	http://www.livejournal.com/~pavelmachek

Then lets add kernel-testers@ to CC.

	Mariusz
