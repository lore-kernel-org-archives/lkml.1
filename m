Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbZFGNYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbZFGNYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZFGNYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:24:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:50512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbZFGNYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:24:18 -0400
Subject: Re: 2.6.30-rc8 Oops whilst booting
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: chris2553@googlemail.com
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200906062215.30571.chris2553@googlemail.com>
References: <200906061959.55592.chris2553@googlemail.com>
	 <200906062215.30571.chris2553@googlemail.com>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 18:55:40 +0530
Message-Id: <1244381140.30664.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

On Sat, 2009-06-06 at 22:15 +0100, Chris Clayton wrote:
> Sorry, I've just realised what a poor report my earlier email was. I should also have said that the 
> kernel has booted succesfully. At the time of reporting I had had two panics. I've just done 
> another git pull, so the kernel is bang up to date with kernel.org, but after building and 
> installing, a reboot resulted in another panic. The system then booted OK after switch off and on 
> again.
> 
> Please cc me to any reply, I'm not subscribed.
> 
> 
> On Saturday 06 June 2009, Chris Clayton wrote:
> > Hi,
> >
> > After a git pull earlier today, I've had oopsen whilst booting the system
> > twice today: A photo of the oops message can be viewed at:
> >
> > http://img231.imageshack.us/img231/8931/dscn0610.jpg
> >
> > I haven't used the 2.6.30-rc kernels very much, so I don't have a clue when
> > the problem was introduced. I have no problems at all with 2.6.29.4.
> >

Can you provide your .config and dmesg of working and non-working
kernel.

Thanks,
--
JSR

