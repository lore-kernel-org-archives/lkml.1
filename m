Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbZLJKfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbZLJKfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933522AbZLJKfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:35:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50274 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933514AbZLJKfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:35:09 -0500
Date: Thu, 10 Dec 2009 11:09:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net,
       Corentin Chary <corentin.chary@gmail.com>,
       Alexandre Rostovtsev <tetromino@gmail.com>
Subject: Re: [PATCH] asus-laptop: add Lenovo SL LenovoCare LED support
Message-ID: <20091210100935.GB2446@ucw.cz>
References: <1260257169-7227-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260257169-7227-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-12-08 15:26:09, Ike Panhc wrote:
> From: Ike Panhc <ikepanhc@canonical.com>
> 
> This patch is to enable the LenovoCare LED support on Lenovo SL laptop. Based
> on the found of the control interface by Alexandre Rostovtsev
> 
> Turn on the LenovoCare LED:
>  (As root privileges) echo 1 > /sys/class/leds/asus\:\:LenovoCare/brightness
> Trun off the LenovoCare LED:
>  (As root privileges) echo 0 > /sys/class/leds/asus\:\:LenovoCare/brightness
> 
> The patch against current checkout of acpi4asus is below.

Is the driver severely misnamed by now? I believe Lenovo and ASUS are
pretty different firms...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
