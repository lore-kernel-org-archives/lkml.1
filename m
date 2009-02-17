Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZBQXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZBQXFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZBQXFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:05:22 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:52477 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZBQXFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:05:22 -0500
Subject: Re: [PATCH] leds: introduce lp5521 led driver
From: Richard Purdie <rpurdie@rpsys.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1234794951-17171-1-git-send-email-felipe.balbi@nokia.com>
References: <1234794951-17171-1-git-send-email-felipe.balbi@nokia.com>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 23:07:12 +0000
Message-Id: <1234912032.5312.68.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-02-16 at 16:35 +0200, Felipe Balbi wrote:
> LP5521 is a three channel led driver with support
> for hardware accelerated patterns (currently used
> via lp5521-only sysfs interface).
> 
> Currently, it's used on n810 device.

Added to the LED tree, thanks.

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

