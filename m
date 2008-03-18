Return-Path: <linux-kernel-owner+w=401wt.eu-S935245AbYCSUwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935245AbYCSUwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbYCSTqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:46:46 -0400
Received: from catapult-mx.catapult.com ([192.94.66.29]:1039 "EHLO
	Catapult-mx.catapult.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbYCSTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:46:45 -0400
Subject: Re: Timer interrupt stops, causes soft lockup
From: "Joel K. Greene" <joel.greene@catapult.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080317154639.GA4102@ucw.cz>
References: <1205235450.18463.45.camel@linuxdt036.nc.catapult.com>
	 <47D6423D.1E6F.00AA.0@novell.com>
	 <1205255048.18463.60.camel@linuxdt036.nc.catapult.com>
	 <1205260328.18463.67.camel@linuxdt036.nc.catapult.com>
	 <47D68B9D.1E6F.00AA.0@novell.com>
	 <1205265642.18463.82.camel@linuxdt036.nc.catapult.com>
	 <1205322793.20205.9.camel@linuxdt036.nc.catapult.com>
	 <1205326713.20205.27.camel@linuxdt036.nc.catapult.com>
	 <1205332212.20205.33.camel@linuxdt036.nc.catapult.com>
	 <1205510009.29658.83.camel@linuxdt036.nc.catapult.com>
	 <20080317154639.GA4102@ucw.cz>
Content-Type: text/plain
Organization: Catapult Communications Corporation
Date: Tue, 18 Mar 2008 10:40:18 -0400
Message-Id: <1205851218.2023.14.camel@linuxdt036.nc.catapult.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,


> Does nosmp help?
We have not tried. I would expect that it would, but I think that's
changing the system too much, and we cannot do that in production. As we
have seen system run for a couple of months without demonstrating the
issue I think that proving the negative is very difficult. I am focusing
on trying to force the issue so we can gather information.
> 
> Does noapic/nolapic help?
These do not affect the problem.


Thanks!

Joel.

