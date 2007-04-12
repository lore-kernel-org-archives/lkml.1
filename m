Return-Path: <linux-kernel-owner+w=401wt.eu-S1161429AbXDLICe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161429AbXDLICe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 04:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161577AbXDLICd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 04:02:33 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36734 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161429AbXDLICb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 04:02:31 -0400
Date: Thu, 12 Apr 2007 10:02:20 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Helge Hafting <helgehaf@aitel.hist.no>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
In-Reply-To: <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
 <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org>
 <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007, Jiri Kosina wrote:

> Could you please
> - try booting without any HID devices plugged in (i.e. usb mice, usb 
>   keyboards) if the problem persists?
> - recompile 2.6.21-rc6-mm1 with git-hid.patch reverted to see if it helps?

Do you compile with CONFIG_HIDRAW?

-- 
Jiri Kosina
