Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0CBXGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:06:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab0CBXGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:06:04 -0500
Date: Tue, 2 Mar 2010 15:05:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] LED driver for the Soekris net5501 board.
Message-Id: <20100302150547.103b8fa2.akpm@linux-foundation.org>
In-Reply-To: <1267376473-9204-1-git-send-email-gurligebis@gentoo.org>
References: <1267376473-9204-1-git-send-email-gurligebis@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Feb 2010 17:01:13 +0000
Bjarke Istrup Pedersen <gurligebis@gentoo.org> wrote:

> LED driver for the Soekris net5501 board.

Thanks, I queued this for sending to Richard.

> It is based on the previously submitted code by Alessandro Zummo, but is changed to use the new GPIO driver with 2.6.33, and the driver has been moved to drivers/leds where it belongs.

It should have Alessandro's Signed-off-by: at least.

It perhaps should have his From:, also.  Please work out with Alessandro
who should be credited as primary author of this driver.

> Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
>
> ...
>
