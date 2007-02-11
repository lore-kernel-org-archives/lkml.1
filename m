Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXBKScP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXBKScP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbXBKScP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:32:15 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63376 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbXBKScO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:32:14 -0500
Date: Sun, 11 Feb 2007 12:31:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: NAK new drivers without proper power management?
In-reply-to: <fa.EgQN5JpU6xrZSLyOY0kWjJ26hUM@ifi.uio.no>
To: Willy Tarreau <w@1wt.eu>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Message-id: <45CF60F2.5020308@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
 <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
 <fa.DhkemAgVI60diqZy0t9GzpwyLmk@ifi.uio.no>
 <fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no>
 <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no>
 <fa.EgQN5JpU6xrZSLyOY0kWjJ26hUM@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Nigel, don't take it as a personal offense, but I think it is a very
> centric view of Linux usages. Where I work, Linux is used a lot on
> servers and appliances. It is used for mail relays, HTTP proxies,
> anti-viruses, firewalls, routers, load balancers, UTM, SSH relays,
> etc... Nobody would ever want to enable power management on those
> machines, let alone suspend which would cause a major havoc, would
> the system decide to enter suspend for any reason.
> 
> Many people also have Linux on their notebooks, but as a dual-boot. You
> read the word ? "dual-boot". It means that they cleanly shutdown their
> system every time they don't use it anymore, and they won't know what
> OS they'll use next time.
> 
> I've never heard anyone there complaining "oh, I'm fed up with this
> boring boot, I always have to wait 30 seconds when I need to do
> something, I wish I could suspend and resume". It is considered the
> normal way of using their PCs.

I think your experience is rather different than that of Joe Average 
User who doesn't frequent kernel lists, and also I think you'll find 
that for a lot of Linux laptop users that don't use supend, the reason 
is that it doesn't work reliably, quite often due to driver issues.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

