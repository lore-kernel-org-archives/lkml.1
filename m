Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbZJFQBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbZJFQBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbZJFQBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:01:06 -0400
Received: from poutre.nerim.net ([62.4.16.124]:49604 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932855AbZJFQBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:01:05 -0400
Date: Tue, 6 Oct 2009 18:00:27 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Brad Campbell <brad@wasp.net.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
Message-ID: <20091006180027.4b1666cf@hyperion.delvare>
In-Reply-To: <4ACB653B.9090707@msgid.tls.msk.ru>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	<68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
	<4AC939BB.8090600@wasp.net.au>
	<68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
	<4ACA21E8.6080501@msgid.tls.msk.ru>
	<68676e00910060800h4cb84dcl9f610f6b23a88e5c@mail.gmail.com>
	<4ACB60A7.307@msgid.tls.msk.ru>
	<68676e00910060834p338c77c8kae8156a1f8dc68a9@mail.gmail.com>
	<4ACB653B.9090707@msgid.tls.msk.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Oct 2009 19:41:47 +0400, Michael Tokarev wrote:
> Luca Tettamanti wrote:
> > In term of Q-FAN profiles: yes, but I still haven't managed to make it
> > work (the interface is there though).
> 
> Oh, so it's basically boils down to Silent/Optimal/Normal choices
> as in the BIOS settings, right?  I mean, still no pwm_* controls
> as it87 offers?..

Probably not. But feel free to bother Asus about it. If they don't
provide the level of control you want, they should know about it, and
make it better in future products. Or even in current products through
BIOS upgrades.

-- 
Jean Delvare
