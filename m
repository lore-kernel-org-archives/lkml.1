Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbXKIIbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbXKIIbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 03:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXKIIbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 03:31:15 -0500
Received: from mx0.towertech.it ([213.215.222.73]:41064 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751282AbXKIIbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 03:31:14 -0500
Date: Fri, 9 Nov 2007 09:30:08 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: vapier.adi@gmail.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [rtc-linux] [patch] tweak driver documentation for rtc periodic
Message-ID: <20071109093008.6d533996@i1501.lan.towertech.it>
In-Reply-To: <200711070417.00969.vapier.adi@gmail.com>
References: <200711070417.00969.vapier.adi@gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007 04:17:00 -0500
Mike Frysinger <vapier.adi@gmail.com> wrote:

> 
> The max_user_freq member is not really meant for RTC drivers to modify, so
> update the rtc documentation so drivers writers know what is expected of them
> when handling periodic events.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

--

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

