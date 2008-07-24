Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYGXJZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYGXJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYGXJZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:25:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48004 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751104AbYGXJZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:25:10 -0400
Date: Thu, 24 Jul 2008 10:06:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       jgarzik@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [build failure] hp-plus.c: (.text+0xd7c1a): undefined reference
 to `ei_close'
Message-ID: <20080724100615.764bac36@lxorguk.ukuu.org.uk>
In-Reply-To: <20080724052603.GA8744@elte.hu>
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp>
	<20080721191519.GA15843@elte.hu>
	<20080721214258.787a67ca@lxorguk.ukuu.org.uk>
	<20080722072334.GA25241@elte.hu>
	<48865899.3030209@garzik.org>
	<20080723104520.GA20672@elte.hu>
	<20080724052603.GA8744@elte.hu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 07:26:03 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> not sure it's known but despite all the fixes i still get:

I'll have a look at this next week or possibly the week after. The
original patches worked but they spent 3 months going round in circles
and I've completely given up even trying to work out what happened or why
all the previous updates I sent were ignored.

Alan
