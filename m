Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbXJYCXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbXJYCXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbXJYCXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:23:35 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:18257 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbXJYCXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:23:34 -0400
Date: Wed, 24 Oct 2007 22:18:54 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Hardware Monitor LM70: Convert semaphore to mutex
Message-ID: <20071025021854.GE30546@jupiter.solarsys.private>
References: <20071024125909.GA9095@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024125909.GA9095@traven>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

* Matthias Kaehlcke <matthias.kaehlcke@gmail.com> [2007-10-24 14:59:09 +0200]:
> Hardware Monitor LM70: Convert the semaphore lm70->sem to the mutex
> API
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

