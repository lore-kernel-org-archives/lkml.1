Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbXG2Dam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbXG2Dam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 23:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbXG2Dad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 23:30:33 -0400
Received: from zaphod.dth.net ([85.159.112.68]:33418 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXG2Dac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 23:30:32 -0400
Date: Sun, 29 Jul 2007 05:30:30 +0200
From: Danny ter Haar <dth@dth.net>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
Message-ID: <20070729033030.GA24636@dth.net>
References: <20070727193832.GA20289@dth.net> <200707290142.53689.bzolnier@gmail.com> <20070729012324.GA29723@dth.net> <46ABFFE4.3060703@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46ABFFE4.3060703@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gabriel C (nix.or.die@googlemail.com):
> Maybe try to : 
> disable BSG ( maybe some leftover bug )
> boot acpi=off ( that got merged kind late )

My first git disected kernel wouldn't boot, but with
acpi=off it would indeed boot!

As did the 2.6.23-rc1-git5 kernel...

I will bisect further to find out exactly what patch is
playing up in my particular setup.

thanks for the tip! ;-)

Danny

-- 
