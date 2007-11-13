Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbXKME4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbXKME4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbXKME4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:56:01 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:48567 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbXKME4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:56:01 -0500
Subject: Re: [PATCH] module loader should not complain about unknown symbol
From: Jon Masters <jonathan@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Teoh <htmldeveloper@gmail.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <200711131540.07211.rusty@rustcorp.com.au>
References: <1194877107.5656.31.camel@localhost.localdomain>
	 <200711131352.23244.rusty@rustcorp.com.au>
	 <804dabb00711122008t3baa8abbr81ef8ec37e8016a1@mail.gmail.com>
	 <200711131540.07211.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 12 Nov 2007 23:55:19 -0500
Message-Id: <1194929719.5946.196.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty,

I read your previous email and thought I'd play with it...and then by
the time I got around to having some time tonight you'd already done it.
You're a machine :-) We actually have some other stuff failing at work
due to this exact bug so I will test against RHEL5 tomorrow also.

Jon.


