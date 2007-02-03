Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbXBCXdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbXBCXdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 18:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXBCXdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 18:33:03 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:3484 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbXBCXdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 18:33:01 -0500
Message-ID: <45C51B81.5040309@jonmasters.org>
Date: Sat, 03 Feb 2007 18:32:17 -0500
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi[sz]ation Of Broken Dreams
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Ban module license tag string termination trick
References: <MDEHLPKNGKAHNMBLJOLKEEJIBFAC.davids@webmaster.com>	<Pine.LNX.4.61.0702032136430.13874@yvahk01.tjqt.qr> <20070203222141.6f723fd9@localhost.localdomain>
In-Reply-To: <20070203222141.6f723fd9@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> On Sat, 3 Feb 2007 21:47:36 +0100 (MET)
> Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> 
>> On Feb 3 2007 10:31, David Schwartz wrote:
>>> The way out of the GPL problem is to make clear that it is *not* a 
>>> copyright enforcement scheme
>> So why do we have EXPORT_SYMBOL_GPL then, if
> 
> Because if you go around modifying code to get around it then regardless
> of the DMCA question you are actively doing it and there is very clear
> intent to do other than the right holder intended. In some ways its the
> difference between walking through an open archway into a private area
> and kicking the door down to get in.

It's a sign, a notice, and the reason I brought up this discussion is 
precisely because I don't think the kernel has any business being an 
enforcement mechanism - that's not what the spirit of our community is 
really about, we're about openness (as much as is possible).

If I go into an airport, open my laptop and connect to a network called 
"Free WiFi network", then I might have a good case to argue that I 
expected the WiFi to be free. If I connect to a network called "Not 
Free, Don't Use" then...I think the intent of the wording is clear.

Anyway. Are we doing this or not - the more I think about it, the more 
I'm kinda "happy" to just leave things as they are. Yes, bad people will 
continuing doing bad things no matter what we do. Do we really want to 
change stuff just to work around obvious abuse? Alan?

Jon.
