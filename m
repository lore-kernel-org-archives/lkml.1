Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbZD2A4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbZD2A4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 20:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZD2A4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 20:56:11 -0400
Received: from senator.holtmann.net ([87.106.208.187]:39914 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbZD2A4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 20:56:10 -0400
Subject: Re: BUG: sleeping function called from invalid context at
 mm/slub.c:1595 --- "hcitool cc" or "l2ping"
From: Marcel Holtmann <marcel@holtmann.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F704301E3F5C7F5@SC-VEXCH1.marvell.com>
References: <477F20668A386D41ADCC57781B1F704301E3F5C7F5@SC-VEXCH1.marvell.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 17:56:05 -0700
Message-Id: <1240966565.997.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bing,

> I'm getting this error whenever I use "hcitool cc" or "l2ping xx:xx:xx:xx:xx:xx"  command.
> 
> Kernel: version 2.6.30-rc3 from bluetooth-testing tree
> HCI Tool: version 3.20
> Laptop: Lenovo X61s

can you rebase the bluetooth-testing.git tree from a few hours ago and
test again.

Regards

Marcel


