Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYI3Mru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYI3Mru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYI3Mrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:47:39 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:42601 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbYI3Mrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:47:39 -0400
From: Frans Pop <elendil@planet.nl>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: CD tray closes spontaneously after opening it
Date: Tue, 30 Sep 2008 14:47:35 +0200
User-Agent: KMail/1.9.9
Cc: "Tony Vroon" <tony@vroon.org>, linux-kernel@vger.kernel.org,
       "Tejun Heo" <tj@kernel.org>, "Jens Axboe" <jens.axboe@oracle.com>
References: <200809301247.05367.elendil@planet.nl> <200809301401.23160.elendil@planet.nl> <ac3eb2510809300535s1a9a1dk1bd8b1080385e864@mail.gmail.com>
In-Reply-To: <ac3eb2510809300535s1a9a1dk1bd8b1080385e864@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301447.35915.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2008 12:47:36.0433 (UTC) FILETIME=[B7027610:01C922FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008, Kay Sievers wrote:
> You might need:
> http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=f755fd56
>57b619fd27160ad202fc5d773d096e9c

Yes, I'd seen that new rule, but:
- that fix is already included in the udev version I'm using
- I'm seeing the issue on /dev/hda (IDE DVD drive), not on /dev/sr*
