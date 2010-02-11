Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab0BKSFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:05:35 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:60142 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab0BKSFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:05:32 -0500
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Feb 2010 13:05:31 EST
Subject: Re: [PATCH] leds: Kconfig cleanup
From: Richard Purdie <rpurdie@rpsys.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <201001201608.30694.hartleys@visionengravers.com>
References: <201001201608.30694.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 17:50:28 +0000
Message-ID: <1265910628.4689.7.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 16:08 -0700, H Hartley Sweeten wrote:
> Remove the need for "depends on LEDS_CLASS" by wrapping the affected
> config options in an if/endif block. Similar for "depends on LEDS_TRIGGERS".
> 
> LEDS_COBALT_RAQ still has a "depends on LEDS_CLASS=y" since it cannot
> be selected to build as a module.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>

Queued in the leds tree, thanks.

Richard

