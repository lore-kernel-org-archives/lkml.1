Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZFGPRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZFGPRr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbZFGPRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:17:39 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:48046 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbZFGPRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:17:38 -0400
Date: Sun, 07 Jun 2009 15:54:58 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
Message-ID: <506D26C038%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4A2934F5.4050601@tuffmail.co.uk>
Mail-Followup-To: Pekka Enberg <penberg@cs.helsinki.fi>, Corentin Chary 
 <corentin.chary@gmail.com>, acpi4asus-user@lists.sourceforge.net, 
 len.brown@intel.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.58.3.3080 (Qt/4.5.1) (Linux-x86_64)
X-NuLabour-Date: Sun, 8955 Dec 1984 15:54:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Alan Jenkins may or may not have written...

> Btw I've now tested the udev rule, you can just dump this in a new .rules
> file under /etc/udev/rules.d:

> SUBSYSTEM=="usb", ATTR{idVendor}=="eb1a", ATTR{idProduct}=="2761", ATTR{power/level}="auto"

And a similar line for 05e3:0505, which seems to be working fine here.

[snip]
-- 
| Darren Salt      | linux at youmustbejoking | nr. Ashington, | Doon
| Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + Buy less and make it last longer.         INDUSTRY CAUSES GLOBAL WARMING.

Nobody expects the Spanish Inquisition!
