Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYEWIpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYEWIpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 04:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYEWIpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 04:45:05 -0400
Received: from www.tglx.de ([62.245.132.106]:56058 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYEWIpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 04:45:04 -0400
Date: Fri, 23 May 2008 10:44:54 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <Uwe.Kleine-Koenig@digi.com>
Cc: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
 interrupts
Message-ID: <20080523104454.4e2af6ec@bluebox.local>
In-Reply-To: <20080523055527.GA28963@digi.com>
References: <20080522192252.GB3226@local>
	<20080522192637.GC3226@local>
	<20080523055527.GA28963@digi.com>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 23 May 2008 07:55:27 +0200
schrieb Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>:

> Hello Hans,
> 
> > -      Copyright (c) 2006 by Hans-JÃŒrgen Koch.</para>
> > +      Copyright (c) 2006-2008 by Hans-JÃŒrgen Koch.</para>
> This looks wrong.

DocBook XML is supposed to be UTF-8.

Thanks,
Hans

> 
> 	ukleinek@zentaur:~$ echo Hans-JÃŒrgen | iconv -t ISO8859-15
> 	Hans-Jürgen
> 
> Best regards
> Uwe
> 
