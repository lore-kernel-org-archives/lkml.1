Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbYIUT6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbYIUT6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYIUT61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:58:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40303 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751462AbYIUT60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:58:26 -0400
Date: Sun, 21 Sep 2008 20:57:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Arjan van de Ven <arjan@infradead.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
 restart.
Message-ID: <20080921205744.2d78f1fa@lxorguk.ukuu.org.uk>
In-Reply-To: <20080921190050.GA20484@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru>
	<20080921110422.1d010b96@infradead.org>
	<20080921182835.GA11473@2ka.mipt.ru>
	<20080921113513.16677c4e@infradead.org>
	<20080921190050.GA20484@2ka.mipt.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Getting the fact, that rmmod/insmod does not always fix the problem (but
> most of the time for a short period of time), I again want to point,
> that it looks like a firmware problem related to some inner timings. You
> ask me to fix the driver and do not even listen to what I said
> previously and do not get that into account and analyze.

Try putting it into D3 counting to 10 and powering it back up. Thats
about as close as you can get to pulling the plug when it hangs.

Alan
