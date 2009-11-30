Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZK3TTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZK3TTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZK3TTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:19:45 -0500
Received: from lo.gmane.org ([80.91.229.12]:36900 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbZK3TTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:19:42 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: pci=off
Date: Mon, 30 Nov 2009 20:18:56 +0100
Message-ID: <20091130201856.43adcc38@schatten.dmk.lab>
References: <web-96228708@zbackend1.aha.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: f053213122.adsl.alicedsl.de
In-Reply-To: <web-96228708@zbackend1.aha.ru>
X-Newsreader: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Nov 2009 16:52:50 -0400
"werner" <w.landgraf@ru.ru> wrote:

> "werner" <w.landgraf@ru.ru>
> In the last time, more and more laptops have problems to 
> boot with Linux.
> 
> The most frequent problem is that IDE drives are not 
> found, or cannot be accessed because reclaimed as ocupied. 
>   The only mean to access them and to get it booted, is 
> with pci=off.   However, with this, the system becomes 
> almost unuseable, lspci also shows nothing.      ITS 
> NECESSARY THAT SOMEONE MAKE A KERNEL PARAMETER  pci=noide 
> , so that all hardware is registered, with exception of 
> ide (and sata) drives   !!!!   This problem, for example, 
> also happens on IBM/Lenovo Thinkpad laptops.

i run on thinkpad r61 . i have experienced no problems.
what specific model are you running into trouble and with what
specific kernel-configuration? 

maybe this helps: http://tuxmobil.org/ibm.html 


> 
> A Toshibe Satelite laptop, I need go back to kernel 2.6.23 
> . With later kernels, at the beginning of the boot the 
> screen become black and nothing more happened.  The same 
> happens on that laptop with all newer Slackware kernels

did you try any recent fedora/ubuntu/debian live-dvds? this is normally
the easiest way to check if there is a real problem or if it is only a
kernel-configuration issue. 

cheers,
flo

