Return-Path: <linux-kernel-owner+w=401wt.eu-S935990AbXGZQoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935990AbXGZQoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935504AbXGZQl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:41:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58276 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935498AbXGZQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:41:26 -0400
Date: Thu, 26 Jul 2007 18:41:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Kyle Rose <krose@krose.org>
cc: Kyle Rose <krose@akamai.com>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
In-Reply-To: <46A8CC41.306@krose.org>
Message-ID: <Pine.LNX.4.64.0707261840480.12711@fbirervta.pbzchgretzou.qr>
References: <46A8BAD4.8020004@akamai.com> <Pine.LNX.4.64.0707261826180.12711@fbirervta.pbzchgretzou.qr>
 <46A8CC41.306@krose.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 26 2007 12:30, Kyle Rose wrote:
>> Sorry for the nitpick, it can be done easier :)
>
>I'm sure it can.  I didn't want to have to figure out the kernel build
>system just to get this one driver working.  Hence my desire for it to
>remain in the kernel proper until sky2 utterly works. ;-)

Oh it's really easy, have a look at
https://dev.computergmbh.de/svn/misc_kernel/oopser/trunk/Makefile


	Jan
-- 
