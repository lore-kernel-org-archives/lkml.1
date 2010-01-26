Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160Ab0AZGBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0AZGBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368Ab0AZGBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:01:36 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:14151 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0AZGBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:01:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=U8rrVHnHTho/WZON9SP8fgkvNWlIXQ2wn8KlQ9/X1GrX/JTYYkZNfOz1TLIwEw+xxx
         rvZMzkKEIslBHsoqA3PaQGstq7ybJGD312YHj14wtgYp6EIF2qSXWDRlEDBX9BPLuyfP
         YpQ5UUB9QneOiLmmMemBlo49bFls2//9uoBV8=
MIME-Version: 1.0
In-Reply-To: <4B5E092B.3070801@gmail.com>
References: <1264179837-22999-1-git-send-email-u.kleine-koenig@pengutronix.de> 
	<20100125013421.GL26562@trinity.fluff.org> <4B5CFEBE.2070906@gmail.com> 
	<20100125074242.GA12480@pengutronix.de> <4B5E092B.3070801@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 26 Jan 2010 14:01:15 +0800
Message-ID: <f17812d71001252201n215f2a9y1906fef630726dbe@mail.gmail.com>
Subject: Re: [PATCH] RFC: make struct platform_driver.id_table const
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: Vikram Dhillon <opensolarisdev@gmail.com>,
       linux-arm-kernel@lists.infradead.org, Eric Miao <eric.miao@marvell.com>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seems to remember a similar patch sent to GregKH weeks ago and
should be sitting somewhere but this one looks to be more complete.

Uwe, maybe you can file an incremental patch, or GregKH may help
to drop mine and merge this instead, either way is OK to me.

- eric
