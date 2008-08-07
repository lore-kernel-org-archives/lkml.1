Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYHGRsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYHGRsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYHGRs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:48:27 -0400
Received: from lap75545.ornl.gov ([160.91.210.54]:44005 "EHLO
	lap75545.ornl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYHGRs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:48:27 -0400
X-Greylist: delayed 949 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 13:48:27 EDT
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1218128219.14483.7.camel@jaswinder.satnam>
References: <1218128219.14483.7.camel@jaswinder.satnam>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Aug 2008 13:30:22 -0400
Message-Id: <1218130222.18118.7.camel@lap75545.ornl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-07 at 22:26 +0530, Jaswinder Singh wrote:
>       firmware: avoiding multiple replication for same firmware file

If this is the last patch you sent to the list, I think there are still
locking bugs in it. I was short on time, so I didn't give it a full
review, but I remember seeing problems. I'll try to give it some time
tonight, if Andrew doesn't beat me to it.

>       typhoon: use request_firmware

This is untested -- again, no time over the weekend -- and I'd rather
not have it go upstream until has been verified.


