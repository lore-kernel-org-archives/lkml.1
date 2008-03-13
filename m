Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYCMNN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYCMNN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYCMNNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:13:21 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:55711 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbYCMNNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:13:20 -0400
Date: Thu, 13 Mar 2008 14:13:11 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: Is there a wireless PCI/e card that is supported in the kernel?
Message-ID: <20080313131311.GA817@citd.de>
References: <alpine.DEB.1.00.0803130827490.18866@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803130827490.18866@p34.internal.lan>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.03.2008 08:39, Justin Piszcz wrote:
>
> Any comments or success stories of GOOD working cards without the use of  
> ndiswrapper?

I would use a WLAN-router or bridge.


I recently bought a DSL-router with WLAN functionality and after a 
little testing i realized that it also acts like a bridge. Any WLAN 
device can reach any wired device on the switch where i connected the 
WLAN-router.

No drivers, no hassle, just a wasted IP for reaching the web-interface 
of the router. ;-)

Altough i don't know if it is a standard feature or not, it just worked 
in my case. :-)

Pro:
- Easy to setup, use & change

Con:
- No direct control within the server



Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

