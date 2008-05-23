Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbYEWF6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbYEWF6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYEWF6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:58:30 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:16982 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYEWF63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:58:29 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-10.tower-37.messagelabs.com!1211522308!1441147!2
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 23 May 2008 07:55:27 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Message-ID: <20080523055527.GA28963@digi.com>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080522192637.GC3226@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 May 2008 05:55:27.0537 (UTC) FILETIME=[99BCE210:01C8BC99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

> -      Copyright (c) 2006 by Hans-JÃŒrgen Koch.</para>
> +      Copyright (c) 2006-2008 by Hans-JÃŒrgen Koch.</para>
This looks wrong.

	ukleinek@zentaur:~$ echo Hans-JÃŒrgen | iconv -t ISO8859-15
	Hans-Jürgen

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
