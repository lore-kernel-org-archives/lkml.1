Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbXB0WBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbXB0WBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 17:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbXB0WBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 17:01:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38374 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbXB0WBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 17:01:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kristian =?iso-8859-15?q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
Date: Tue, 27 Feb 2007 23:04:01 +0100
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <1172601905.5428.28.camel@localhost.localdomain>
In-Reply-To: <1172601905.5428.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702272304.01756.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 27 February 2007 19:45, Kristian Grønfeldt Sørensen wrote:
> Hi.
> 
> PROBLEM: "BUG:" when resumimg from suspend-to-ram 
> 	
> My laptop have a problem with resuming from suspend-to-ram. 
> It does not occur every time - most of the time, resume works without
> any problem.at all.
> 
> After it occurs, the laptop refuses to go into suspend-to-ram mode until
> next reboot.

What do you mean by "refuses"?  Are there any suspicious messages in
dmesg?

> The system is a Debian unstable running with a self-compiled 2.6.20
> kernel downloaded from kernel.org. 
> 
> I've only tried suspend-to-ram on 2.6.20 so I don't know whether or not
> other versions might have the same problem.
> 
> I'm not subscribed to the list. Please CC me.

I guess one of the drivers you use goes awry at some point.  Please provide
us with more information (like dmesg output after a failing resume).

Greetings,
Rafael
