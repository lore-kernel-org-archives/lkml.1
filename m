Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbXGNPhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbXGNPhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 11:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXGNPhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 11:37:01 -0400
Received: from stinky.trash.net ([213.144.137.162]:35992 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXGNPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 11:37:00 -0400
Message-ID: <4698ED6E.6020502@trash.net>
Date: Sat, 14 Jul 2007 17:36:14 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, netdev@vger.kernel.org
Subject: Re: [PATCH] NET_CLS_RSVP6 should depend on IPV6
References: <4698A7B6.1030302@googlemail.com>
In-Reply-To: <4698A7B6.1030302@googlemail.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> cls_rsvp6 only works with IPV6 enabled kernels and IMO it should depends
> on IPV6.


I can't see any functional dependency on IPv6, what exactly are you
refering to? People might want to use it on a bridge for example
without having IPv6 running locally.


