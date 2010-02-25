Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab0BYDj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:39:28 -0500
Received: from mail.perches.com ([173.55.12.10]:1201 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758899Ab0BYDj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:39:27 -0500
Subject: Re: [PATCH 03/06] kernel.h hexdump cleanup
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20100224181646.bde9c183.akpm@linux-foundation.org>
References: <20100222141934.GA9030@darkstar>
	 <1266867811.10646.196.camel@Joe-Laptop.home>
	 <a8e1da1002241752u637f7debi2ff46f50ac5edcd8@mail.gmail.com>
	 <20100224181646.bde9c183.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 19:39:24 -0800
Message-ID: <1267069164.30508.7.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 18:16 -0800, Andrew Morton wrote: 
> Avoiding bisection-bustage is hardly a priority any more, but
> let's not break bisection this time if we can avoid it.

I think that kernel.h could use a lot more cleaning than this.

Separating it into multiple pieces is OK, but moving
stuff around to categorize it a bit better is also useful.
I've tried both ways.

Doing it all as one patchset / git commit would be best.

Here's a link to the last time I tried as a 14 patch block

http://patchwork.kernel.org/patch/67829/
http://lkml.org/lkml/2009/12/16/77


