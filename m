Return-Path: <linux-kernel-owner+w=401wt.eu-S933643AbZJNW02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbZJNW02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932656AbZJNW02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:26:28 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:65014 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630AbZJNW01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:26:27 -0400
Subject: Re: [PATCH] leds-alix2c: take port address from MSR
From: Richard Purdie <rpurdie@rpsys.net>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Constantin Baranov <const@mimas.ru>
In-Reply-To: <1254745347-32307-1-git-send-email-daniel@caiaq.de>
References: <1254745347-32307-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 19:21:00 +0100
Message-Id: <1255544460.14634.15.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 20:22 +0800, Daniel Mack wrote:
> This makes the LEDs driver for ALIX2.C boards work with Coreboot by
> looking up the port address in the MSR rather than hard-coding it.
> 
> The BIOS scan also needed some tweaks as the string in Coreboot differs
> from the one in the legacy BIOS.
> 
> Successfully tested with both the legacy tinyBIOS as well as Coreboot
> v3.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>

Queued in the LED tree, thanks.

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

