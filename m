Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbXG1O2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbXG1O2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 10:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbXG1O2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 10:28:14 -0400
Received: from smtp161.iad.emailsrvr.com ([207.97.245.161]:42572 "EHLO
	smtp161.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbXG1O2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 10:28:13 -0400
Message-ID: <46AB5222.1060404@gentoo.org>
Date: Sat, 28 Jul 2007 10:26:42 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: zd1211b question.
References: <200707280755.34930.gene.heskett@gmail.com>
In-Reply-To: <200707280755.34930.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> This last one is the right set of numbers.  However, I'll be dipped but I 
> can't find anyplace in a make xconfig in the 2.6.22.1-rt9 tree, to turn on 
> the building of that driver.

Sounds like you haven't satisfied the dependencies or are looking in the 
wrong menu.

Under menuconfig you can type: /ZD1211<enter>

That will tell you where abouts it resides, and it's dependencies.

You'll also need firmware with this driver. See 
http://www.linuxwireless.org/en/users/Drivers/zd1211rw

Daniel
