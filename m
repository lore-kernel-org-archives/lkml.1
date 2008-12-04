Return-Path: <linux-kernel-owner+w=401wt.eu-S1751063AbYLDQCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063AbYLDQCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYLDQCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:02:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59667 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYLDQCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:02:22 -0500
Date: Thu, 4 Dec 2008 13:58:55 +0100
From: Pavel Machek <pavel@suse.cz>
To: peter meng <mengsanshui@yahoo.com.cn>
Cc: Iwo Mergler <iwo@call-direct.com.au>, linux-kernel@vger.kernel.org
Subject: Re: I want to know how to write a lcd driver with spi interface
Message-ID: <20081204125855.GA2294@ucw.cz>
References: <49346E8E.9050707@call-direct.com.au> <648837.22167.qm@web15702.mail.cnb.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <648837.22167.qm@web15702.mail.cnb.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-02 11:40:14, peter meng wrote:
> Hi,Iwo
> 
> Thank you very mach .
> I'm a newbie on video driver .
> Could you recommended the lcd driver that already use spi interface on Linux  to me ?
> I want to emulate it .
> 

drivers/auxdisplay should be interesting reading.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
