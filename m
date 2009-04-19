Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZDSUDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZDSUDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 16:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbZDSUDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 16:03:08 -0400
Received: from khc.piap.pl ([195.187.100.11]:54504 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688AbZDSUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 16:03:07 -0400
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] 2.6.30-rc broke ixp4xx_eth, firmware breakage?
References: <200904182153.n3ILrP6j027453@pilspetsen.it.uu.se>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 19 Apr 2009 22:03:02 +0200
In-Reply-To: <200904182153.n3ILrP6j027453@pilspetsen.it.uu.se> (Mikael Pettersson's message of "Sat\, 18 Apr 2009 23\:53\:25 +0200 \(MEST\)")
Message-ID: <m3vdp0pg21.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:

> The ixp4xx_eth driver for my IXP420 XScale box (Synology DS101)
> worked fine in kernel 2.6.29. Now trying to boot 2.6.30-rc2 I'm
> greeted with the following failure during init:
>
> Bringing up interface eth0:  RTNETLINK answers: No such file or directory
> Failed to bring up eth0.
> [FAILED]

Thanks for the info, will look at it.
-- 
Krzysztof Halasa
