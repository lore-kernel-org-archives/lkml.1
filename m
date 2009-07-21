Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbZGUTlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbZGUTlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZGUTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:41:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33593
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466AbZGUTlv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:41:51 -0400
Date: Tue, 21 Jul 2009 12:41:57 -0700 (PDT)
Message-Id: <20090721.124157.27657617.davem@davemloft.net>
To: u.kleine-koenig@pengutronix.de
Cc: fthain@telegraphics.com.au, gregkh@suse.de, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, geert@linux-m68k.org, akpm@linux-foundation.org
Subject: Re: [PATCH] move macsonic's probe function to .devinit.text
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090721194036.GB10770@pengutronix.de>
References: <alpine.OSX.2.00.0907220032230.796@silk.local>
	<20090721.122058.23378599.davem@davemloft.net>
	<20090721194036.GB10770@pengutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date: Tue, 21 Jul 2009 21:40:36 +0200

> Should I repost the remaining 5 to netdev@?

You should for at least the ones that don't require changes,
but once you fix those other one's up based upon feedback you
should make sure netdev at least gets CC:'d when you post
those too.
