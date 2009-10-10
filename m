Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZJJDNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZJJDNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 23:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZJJDNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 23:13:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:45361 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZJJDNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 23:13:15 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 (and 2.6.32-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <Pine.LNX.4.44L0.0910092201470.25597-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0910092201470.25597-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Oct 2009 14:11:55 +1100
Message-Id: <1255144315.3387.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 22:03 -0400, Alan Stern wrote:

> If it's not a hardware issue and the modem really does work okay in 
> 2.6.31.1, you should also collect a usbmon trace under that kernel for 
> comparison.

I put some logs at:

http://bugzilla.kernel.org/show_bug.cgi?id=14355

BTW. Do we have a nice GUI to browse these or it's time for me to work
on my pygtk skills ? :-)

Cheers,
Ben.


