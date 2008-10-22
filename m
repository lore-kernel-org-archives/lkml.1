Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYJVAgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYJVAgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 20:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYJVAgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 20:36:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:53920 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbYJVAgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 20:36:23 -0400
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: avorontsov@ru.mvista.com
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20081020154835.GA3234@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
	 <200810171324.42650.david-b@pacbell.net>
	 <20081017212942.GA1919@oksana.dev.rtsoft.ru>
	 <200810200029.58312.david-b@pacbell.net>
	 <20081020154835.GA3234@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 11:29:20 +1100
Message-Id: <1224635360.7654.294.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But it doesn't work as a module (i.e. OF-specific bits should be
> always in-kernel).

Why not ?

Ben.


