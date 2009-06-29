Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZF2Myk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZF2Myk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZF2Myd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:54:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33635 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZF2Myc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:54:32 -0400
Date: Mon, 29 Jun 2009 12:57:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       lm-sensors@lm-sensors.org, suchang.woo@samsung.com,
       kyungmin.park@samsung.com
Subject: Re: [PATCH] hwmon: add GP2A002 proximity/ambient sensor
Message-ID: <20090629105704.GA1478@ucw.cz>
References: <4A448926.1030701@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A448926.1030701@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-06-26 17:39:02, Minkyu Kang wrote:
> The GP2A002 is a I2C interfaced Sensor for Proximity/Ambient
> This patch adds support the GP2A002 sensor
> 
> Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
> Signed-off-by: Suchang Woo <suchang.woo@samsung.com>

It would be nice to document what it does and what interface to
userland it provides...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
