Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbYKXAZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbYKXAZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 19:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYKXAZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 19:25:44 -0500
Received: from smtp3.ono.com ([62.42.230.176]:29949 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbYKXAZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 19:25:44 -0500
Date: Mon, 24 Nov 2008 01:25:41 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: no SD card reader
Message-ID: <20081124012541.616c9f84@werewolf.home>
In-Reply-To: <20081123233007.GA3959@srcf.ucam.org>
References: <20081014025453.617f2ef8@werewolf.home>
	<20081014174536.1353d17e@mjolnir.drzeus.cx>
	<20081014232759.08f5d212@werewolf.home>
	<20081123213921.667ecb93@mjolnir.drzeus.cx>
	<4929D803.80708@tuffmail.co.uk>
	<20081123233007.GA3959@srcf.ucam.org>
X-Mailer: Claws Mail 3.6.1cvs37 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2008 23:30:07 +0000, Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Sun, Nov 23, 2008 at 10:24:03PM +0000, Alan Jenkins wrote:
> 
> > Matthew, if I have confused two similar issues, could you please help by 
> > explaining the differences?
> 
> You're correct. On any released version of Linux, the Aspire One's SD 
> slot will only show up if a card was inserted when the machine was 
> booted. That's how it's always been. I have code to fix it, which will 
> land in the 2.6.29 timeframe with luck.
> 

Thanks for the info. Just a couple questions:

- Is there any pointer to a patch that can be applied to current stable
 (2.6.27.6) ?
- I have tried to load acpiphp on the aspire and it says it has
  'No such device'. Does the patch include something to make it load and
  recognize the Aspire's PCI ? Is this module independent or do I need
  also pciephp or shpchp ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.27.5-desktop-1mnb (gcc 4.3.2 (GCC) #1 Sun Nov
