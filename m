Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbYBHI4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbYBHI4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbYBHI4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:56:00 -0500
Received: from otello.alma.unibo.it ([137.204.24.163]:56244 "EHLO
	otello.alma.unibo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbYBHIz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:55:59 -0500
Message-ID: <47AC191E.303@otello.alma.unibo.it>
Date: Fri, 08 Feb 2008 09:55:58 +0100
From: Diego Zuccato <diego@otello.alma.unibo.it>
User-Agent: Thunderbird 2.0.0.9 (X11/20080206)
MIME-Version: 1.0
To: Lee Mathers <Lee.Mathers@tcafs.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>            <20080202123710.42df1aa0@weinigel.se>            <20080202191930.GA19826@kroah.com>            <47A5D895.20300@davidnewall.com>            <47A6E742.80408@otello.alma.unibo.it> <courier.47A8F072.000079E4@hawking.rebel.net.au> <47AAC1EE.6060101@otello.alma.unibo.it> <47AB0911.3060508@davidnewall.com> <47AB5D2B.5010806@tcafs.org>
In-Reply-To: <47AB5D2B.5010806@tcafs.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Mathers ha scritto:

> Now we have hardware ASIC that depend on the most part a (dll in 
> windows) or .ko .o file under linux to provide the entire instruction 
> set.  Think Winmodems,  Winprinters etc....

Well, winmodem case is the only I could *almost* understand 
closed-source drivers: the algorithms used *are* the modem. It's not a 
simple firmware upload.
What I really don't understand are graphic cards producers... If what 
they say about the card is true, then there's no "advanced" algorithm in 
the driver, just (at most) a firmware uploader (that's better suited 
off-kernel anyway)...

Bohf!

BYtE,
  Diego.
