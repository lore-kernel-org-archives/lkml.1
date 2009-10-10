Return-Path: <linux-kernel-owner+w=401wt.eu-S964887AbZJJCtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887AbZJJCtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 22:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934750AbZJJCtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 22:49:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:59107 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934749AbZJJCtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 22:49:13 -0400
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
Date: Sat, 10 Oct 2009 13:48:26 +1100
Message-Id: <1255142906.2219.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 22:03 -0400, Alan Stern wrote:
> > This looks a lot like a hardware problem, such as bad USB cables.  
> > Could you collect a usbmon trace for bus 4?  It ought to show whether
> > this is the case or whether software is at fault.
> 
> If it's not a hardware issue and the modem really does work okay in 
> 2.6.31.1, you should also collect a usbmon trace under that kernel for 
> comparison.

Ok. I'll give those a go later this week-end.

Cheers,
Ben.


