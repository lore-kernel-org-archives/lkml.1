Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbYBLQP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbYBLQP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYBLQPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:15:14 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:61544 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYBLQPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:15:13 -0500
Date: Tue, 12 Feb 2008 10:13:52 -0600
From: MillTek <mill.tek@verizon.net>
Subject: Re: [lm-sensors] [PATCH] hwmon: (adm1026) Properly terminate sysfs
 groups (Was: panic about sysfs with adm1026)
In-reply-to: <20080212163733.461a8684@hyperion.delvare>
To: lm-sensors@lm-sensors.org
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <47B1C5C0.4010902@verizon.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <86802c440802092355l7393fe07gfbd021e9cef66181@mail.gmail.com>
 <20080210171004.GB25353@kroah.com>	<20080210190115.2ebd4124@hyperion.delvare>
 <86802c440802111539w7eeb84dcu97103733364f7a7b@mail.gmail.com>
 <20080212092722.32c30eac@hyperion.delvare>	<20080212152715.GB19441@kroah.com>
 <20080212163733.461a8684@hyperion.delvare>
User-Agent: Thunderbird 2.0.0.9 (X11/20071212)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Kernel 2.6.24 for my distro (Arch Linux) came out in the last few days. 
My board has a Fintek F1882g chip. It means that I can finally get 
voltage and fan speeds for the board, so thanks for that.  I am 
wondering how I correctly calculate the correct offset and factors for 
the voltage numbers? This is what GKrellm says;

Vcor1  1.66  factor 1 offset 0
Vcor2  1.24  factor 1 offset 0
+3.3v   2.83  factor 3  offset 0
+5v      4.82  factor 4.98 offset 0
+12v    3.84 factor 4.0  offset 0
-12v    -4.35  factor -4.0 offset 0
-5v      -1.51  factor -1.667 offset 0
in7      1.66    factor 1  offset 0
in8       1.54   factor 1 offset 0

If there's a website that I should visit can anyone supply a link??


Jim
