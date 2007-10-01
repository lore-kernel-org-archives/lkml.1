Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbXJAHkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbXJAHkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXJAHkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:40:09 -0400
Received: from mail.syneticon.net ([213.239.212.131]:42362 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbXJAHkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:40:08 -0400
Message-ID: <4700A44C.2010700@wpkg.org>
Date: Mon, 01 Oct 2007 09:39:56 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Miguel <mc354@tid.es>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: software unplug and plug USB
References: <46FCF0F5.9030004@wpkg.org> <1191224165.6014.12.camel@McM>
In-Reply-To: <1191224165.6014.12.camel@McM>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel schrieb:
> actually, I have a USB keyboard, could that be the problem? why?

Because when you remove USB modules, USB devices, including USB 
keyboards, won't work...


> removing and adding modules doesn't solve my problem... The USB has
> several functions: modem and usb mass storage and only the storage one
> is recognized 
> :(

What modules exactly do you unload/load again, in what order, using 
which commands?


-- 
Tomasz Chmielewski
http://blog.wpkg.org
