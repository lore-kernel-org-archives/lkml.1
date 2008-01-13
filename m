Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYAMXWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYAMXWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 18:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbYAMXWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 18:22:08 -0500
Received: from tim.rpsys.net ([194.106.48.114]:54504 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbYAMXWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 18:22:07 -0500
Subject: Re: [PATCH] leds: Add support for the 3rd LED on the PCEngines WRAP
From: Richard Purdie <rpurdie@rpsys.net>
To: Michael Loeffler <zvpunry@zvpunry.de>
Cc: linux-kernel@vger.kernel.org, Kristian Kielhofner <kris@krisk.org>
In-Reply-To: <1198762302.15874.6.camel@macbook>
References: <1198762302.15874.6.camel@macbook>
Content-Type: text/plain
Date: Sun, 13 Jan 2008 23:21:54 +0000
Message-Id: <1200266514.4665.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-27 at 14:31 +0100, Michael Loeffler wrote:
> The 3rd LED on this board is something like a power-led, it is on all the
> time. With this change to the leds-wrap driver it is possible to use this
> LED too.
> 
> Signed-off-by: Michael Loeffler <zvpunry@zvpunry.de>
> ---
> Hi
>
> I wonder why there was no support for this LED. This LED and the GPIO
> line is documented in the first commit message (0d75565f) for this
> file.
>
> I use this changed version for five weeks and it just works. I think
> this patch can be included in 2.6.25.

I've queued it up in the LED tree, thanks.

Richard

