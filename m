Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZBFVXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZBFVXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBFVX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:23:29 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:20229 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbZBFVX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:23:28 -0500
Date: Fri, 6 Feb 2009 22:23:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: Uwe =?ISO-8859-15?B?S2xlaW5lLUv2bmln?= <ukleinek@strlen.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, frank@f-seidel.de,
       w.sang@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
Message-ID: <20090206222314.6c2b36f7@hyperion.delvare>
In-Reply-To: <498C96B0.7050408@suse.de>
References: <498C3EEA.5060508@suse.de>
	<20090206183542.GB6361@strlen.de>
	<498C96B0.7050408@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Feb 2009 20:59:44 +0100, Frank Seidel wrote:
> KERN_WARNING is just the standard/default loglevel so that this
> change doesn't introduce different behaviour.

Default log level? That's news to me. Care to elaborate?

-- 
Jean Delvare
