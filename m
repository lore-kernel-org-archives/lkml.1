Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbXFNEKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbXFNEKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 00:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbXFNEKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 00:10:06 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:12547 "EHLO
	asav15.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXFNEKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 00:10:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAHRccEZKhRO4i2dsb2JhbACBTY15AhENBhI
From: Dmitry Torokhov <dtor@insightbb.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Date: Thu, 14 Jun 2007 00:10:01 -0400
User-Agent: KMail/1.9.3
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <200706131620.54338.rjw@sisk.pl> <3ae72650706131520m3091d04et31b1db64be692385@mail.gmail.com>
In-Reply-To: <3ae72650706131520m3091d04et31b1db64be692385@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140010.03438.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 18:20, Kay Sievers wrote:
> Dmitry, you added this recently, is this used in any code you plan to
> merge soon?
>

Yes, I will need it to implement input device resume (mainly to restore LED
state and repeat rate for keyboards).
 
-- 
Dmitry
