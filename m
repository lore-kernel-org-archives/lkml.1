Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZGBRp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZGBRp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZGBRpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:45:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbZGBRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:45:09 -0400
Date: Thu, 2 Jul 2009 10:43:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk regression?
In-Reply-To: <1246556320.28915.92.camel@Joe-Laptop.home>
Message-ID: <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org>  <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>  <1246513356.28915.62.camel@Joe-Laptop.home>  <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain> <1246556320.28915.92.camel@Joe-Laptop.home>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Jul 2009, Joe Perches wrote:
> 
> Maybe, but your printk change does require that all of
> the kernel sources be updated as necessary.

Sure. And if they aren't, nobody really cares.

		Linus
