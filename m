Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886Ab0ARVLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0ARVLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784Ab0ARVLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:11:51 -0500
Received: from poutre.nerim.net ([62.4.16.124]:61858 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab0ARVLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:11:50 -0500
Date: Mon, 18 Jan 2010 22:11:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Peter =?UTF-8?B?SMO8d2U=?= <PeterHuewe@gmx.de>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] video/matrox: Checkpatch cleanups for matroxfb_crtc2.c
Message-ID: <20100118221146.5d81fc0e@hyperion.delvare>
In-Reply-To: <1263844770.26846.134.camel@Joe-Laptop.home>
References: <201001181934.49519.PeterHuewe@gmx.de>
	<1263842269.26846.122.camel@Joe-Laptop.home>
	<201001182027.29805.PeterHuewe@gmx.de>
	<1263844770.26846.134.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 11:59:30 -0800, Joe Perches wrote:
> On Mon, 2010-01-18 at 20:27 +0100, Peter Hüwe wrote:
> > the reason behind this change was that spaces and tabs were mixed for 
> > indention. 
> 
> Checkpatch isn't gospel and isn't always right.
> 
> There should be room for taste preference here
> and I think whatever Petr V's is should prevail.
> 
> > How about this indention? Would this be better?
> 
> Well, I don't think so, but others will have different opinions.

I don't see it as an improvement either. Was checkpatch.pl really
complaining about the alignment? Tabs followed by less than 8 spaces is
acceptable and fairly common AFAICT, I can't remember the script
yelling at me when I do it.


-- 
Jean Delvare
